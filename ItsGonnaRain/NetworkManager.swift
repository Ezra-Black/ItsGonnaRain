//
//  NetworkManager.swift
//  ItsGonnaRain
//
//  Created by Ezra Black on 6/23/21.
//

import Foundation
//move this protocol and struct out to their own files eventually
protocol NetworkingProtocol {
    func fetchCurrentWeather(city: String, completion: @escaping (WeatherModel) -> ())
    func fetchCurrentLocationWeather(lat: String, lon: String, completion: @escaping (WeatherModel) -> ())
    func fetchWeeklyForecast(city: String, completion: @escaping ([ForecastTemperature]) -> ())
}
struct Server {
    static let API_KEY = "10b29f8b23f59520d886d311fa84daea"
}

class NetworkManager : NetworkingProtocol {
    
    func fetchCurrentLocationWeather(lat: String, lon: String, completion: @escaping (WeatherModel) -> ()) {
        let API_URL = "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(Server.API_KEY)"
        
        guard let url = URL(string: API_URL) else {
                 fatalError()
             }
             let urlRequest = URLRequest(url: url)
             URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                 guard let data = data else { return }
                 do {
                     let currentWeather = try JSONDecoder().decode(WeatherModel.self, from: data)
                    completion(currentWeather)
                 } catch {
                     print(error)
                 }
                     
             }.resume()
    }
    
    func fetchCurrentWeather(city: String,
                             completion: @escaping (WeatherModel) -> ()) {
        let formatCity = city.replacingOccurrences(of: " ", with: "+")
        let API_URL = "http://api.openweathermap.org/data/2.5/weather?q=\(formatCity)&appid=\(Server.API_KEY)"
        
        guard let url = URL(string: API_URL) else {
            fatalError()
        }
        
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else { return }
            do {
                let currentWeather = try JSONDecoder().decode(WeatherModel.self, from: data)
                completion(currentWeather)
            } catch {
                print(error)
            }
            
        }.resume()
    }
    
    
    //in general, I could flatten out this data and make it a lot more readable, and pull the logic out of this and put
    //it somewhere more logical.
    func fetchWeeklyForecast(city: String, completion: @escaping ([ForecastTemperature]) -> ()) {
        let formattedCity = city.replacingOccurrences(of: " ", with: "+")
        let API_URL = "http://api.openweathermap.org/data/2.5/forecast?q=\(formattedCity)&appid=\(Server.API_KEY)"
        
        var currentDayTemp = ForecastTemperature(weekDay: nil, hourlyForecast: nil)
        var secondDayTemp = ForecastTemperature(weekDay: nil, hourlyForecast: nil)
        var thirdDayTemp = ForecastTemperature(weekDay: nil, hourlyForecast: nil)
        var fourthDayTemp = ForecastTemperature(weekDay: nil, hourlyForecast: nil)
        var fifthDayTemp = ForecastTemperature(weekDay: nil, hourlyForecast: nil)
        var sixthDayTemp = ForecastTemperature(weekDay: nil, hourlyForecast: nil)
        
    
        guard let url = URL(string: API_URL) else {
                 fatalError()
             }
             let urlRequest = URLRequest(url: url)
             URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, error) in
                guard self != nil else { return }
                 guard let data = data else { return }
                 do {
                    
                    let currentForecast = try JSONDecoder().decode(ForecastModel.self, from: data)
                        
                    var forecastmodelArray : [ForecastTemperature] = []
                    var fetchedData : [WeatherInfo] = [] //Just for loop completion
                    
                    var currentDayForecast : [WeatherInfo] = []
                    var secondDayForecast : [WeatherInfo] = []
                    var thirddayDayForecast : [WeatherInfo] = []
                    var fourthDayDayForecast : [WeatherInfo] = []
                    var fifthDayForecast : [WeatherInfo] = []
                    var sixthDayForecast : [WeatherInfo] = []
                    
                    print("Total data:", currentForecast.list.count)
                    var totalData = currentForecast.list.count //Should be 40 all the time
                    
                    for day in 0...currentForecast.list.count - 1 {
                            
                        let index = day//(8 * day) - 1
                        let mainTemp = currentForecast.list[index].main.temp
                        let minTemp = currentForecast.list[index].main.temp_min
                        let maxTemp = currentForecast.list[index].main.temp_max
                        let descriptionTemp = currentForecast.list[index].weather[0].description
                        let icon = currentForecast.list[index].weather[0].icon
                        let time = currentForecast.list[index].dt_txt!
                    
                        let dateFormatter = DateFormatter()
                        dateFormatter.calendar = Calendar(identifier: .gregorian)
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let date = dateFormatter.date(from: currentForecast.list[index].dt_txt!)
                        
                        let calendar = Calendar.current
                        let components = calendar.dateComponents([.weekday], from: date!)
                        let wkdayComponent = components.weekday! - 1  //Just the integer value from 0 to 6
                        
                        let f = DateFormatter()
                        let weekday = f.weekdaySymbols[wkdayComponent] // 0 Sunday 6 - Saturday //This is where we are getting the string val (Mon/Tue/Wed...)
                            
                        let currentDayComponent = calendar.dateComponents([.weekday], from: Date())
                        let currentWeekDay = currentDayComponent.weekday! - 1
                        let currentweekdaysymbol = f.weekdaySymbols[currentWeekDay]
                        
                        if wkdayComponent == currentWeekDay - 1 {
                            totalData = totalData - 1
                        }
                        
                        
                
                        
                        //I could make this equatable and potentially make this a switch case as well
                        if wkdayComponent == currentWeekDay {
                            let info = WeatherInfo(temp: mainTemp, min_temp: minTemp, max_temp: maxTemp, description: descriptionTemp, icon: icon, time: time)
                            currentDayForecast.append(info)
                            currentDayTemp = ForecastTemperature(weekDay: currentweekdaysymbol, hourlyForecast: currentDayForecast)
                            print("1")
                            fetchedData.append(info)
                        }else if wkdayComponent == currentWeekDay.incrementWeekDays(by: 1) {
                            let info = WeatherInfo(temp: mainTemp, min_temp: minTemp, max_temp: maxTemp, description: descriptionTemp, icon: icon, time: time)
                            secondDayForecast.append(info)
                            secondDayTemp = ForecastTemperature(weekDay: weekday, hourlyForecast: secondDayForecast)
                            print("2")
                            fetchedData.append(info)
                        }else if wkdayComponent == currentWeekDay.incrementWeekDays(by: 2) {
                            let info = WeatherInfo(temp: mainTemp, min_temp: minTemp, max_temp: maxTemp, description: descriptionTemp, icon: icon, time: time)
                            thirddayDayForecast.append(info)
                            print("3")
                            thirdDayTemp = ForecastTemperature(weekDay: weekday, hourlyForecast: thirddayDayForecast)
                            fetchedData.append(info)
                        }else if wkdayComponent == currentWeekDay.incrementWeekDays(by: 3) {
                            let info = WeatherInfo(temp: mainTemp, min_temp: minTemp, max_temp: maxTemp, description: descriptionTemp, icon: icon, time: time)
                            fourthDayDayForecast.append(info)
                            print("4")
                            fourthDayTemp = ForecastTemperature(weekDay: weekday, hourlyForecast: fourthDayDayForecast)
                            fetchedData.append(info)
                        }else if wkdayComponent == currentWeekDay.incrementWeekDays(by: 4){
                            let info = WeatherInfo(temp: mainTemp, min_temp: minTemp, max_temp: maxTemp, description: descriptionTemp, icon: icon, time: time)
                            fifthDayForecast.append(info)
                            fifthDayTemp = ForecastTemperature(weekDay: weekday, hourlyForecast: fifthDayForecast)
                            fetchedData.append(info)
                            print("5")
                        }else if wkdayComponent == currentWeekDay.incrementWeekDays(by: 5) {
                            let info = WeatherInfo(temp: mainTemp, min_temp: minTemp, max_temp: maxTemp, description: descriptionTemp, icon: icon, time: time)
                            sixthDayForecast.append(info)
                            sixthDayTemp = ForecastTemperature(weekDay: weekday, hourlyForecast: sixthDayForecast)
                            fetchedData.append(info)
                            print("6")
                        }

                        //turn into a switch
                        if fetchedData.count == totalData {
                            if currentDayTemp.hourlyForecast?.count ?? 0 > 0 {
                                forecastmodelArray.append(currentDayTemp)
                            }
                            if secondDayTemp.hourlyForecast?.count ?? 0 > 0 {
                                forecastmodelArray.append(secondDayTemp)
                            }
                            if thirdDayTemp.hourlyForecast?.count ?? 0 > 0 {
                                forecastmodelArray.append(thirdDayTemp)
                            }
                            if fourthDayTemp.hourlyForecast?.count ?? 0 > 0 {
                                forecastmodelArray.append(fourthDayTemp)
                            }
                            if fifthDayTemp.hourlyForecast?.count ?? 0 > 0 {
                                forecastmodelArray.append(fifthDayTemp)
                            }
                            if sixthDayTemp.hourlyForecast?.count ?? 0 > 0 {
                                forecastmodelArray.append(sixthDayTemp)
                            }
                            if forecastmodelArray.count <= 6 {
                                completion(forecastmodelArray)
                            }
                        }
                    }
                 } catch {
                     print(error)
                 }
        }.resume()
    }
}
