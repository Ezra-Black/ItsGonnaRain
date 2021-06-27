//
//  NetworkManager.swift
//  ItsGonnaRain
//
//  Created by Ezra Black on 6/23/21.
//

import Foundation
import NotificationCenter
struct Server {
    static let API_KEY = "10b29f8b23f59520d886d311fa84daea"
}

class NetworkManager {
    private let notificationCenter: NotificationCenter
    init(notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter
    }
    
    func fetchCurrentLocationWeather(lat: String,
                                     lon: String,
                                     completion: @escaping (WeatherModel) -> ()) {
        let API_URL = "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(Server.API_KEY)"
        print(API_URL)
        guard let url = URL(string: API_URL) else {
            fatalError()
        }
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else { return }
            do {
                let currentWeather = try JSONDecoder().decode(WeatherModel.self, from: data)
                print(currentWeather)
                completion(currentWeather)
            } catch {
                print(error)
            }
        }.resume()
    }
    
}
