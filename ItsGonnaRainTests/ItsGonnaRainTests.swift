//
//  ItsGonnaRainTests.swift
//  ItsGonnaRainTests
//
//  Created by Ezra Black on 6/23/21.
//

import XCTest
@testable import ItsGonnaRain

/*
Does decoding work? ✅
Does decoding fail when given bad data?✅
Does it build the correct URL?✅
Does it build the correct URLRequest?✅
are the search results saved properly?✅
Is the completion handler called when data is good?✅
Is the completion handler called when data is bad?✅
Is the completion handler called when the network fails?✅
create expectation
create controller
schedule work
then wait
*/


class ItsGonnaRainTests: XCTestCase {
    //could nest this somewhere for cleaner access
    let validJSONSanFran = """
        {
          "coord": {
            "lon": -122.4064,
            "lat": 37.7858
          },
          "weather": [
            {
              "id": 800,
              "main": "Clear",
              "description": "clear sky",
              "icon": "01d"
            }
          ],
          "base": "stations",
          "main": {
            "temp": 293.22,
            "feels_like": 293.19,
            "temp_min": 289.32,
            "temp_max": 300.94,
            "pressure": 1014,
            "humidity": 73
          },
          "visibility": 10000,
          "wind": {
            "speed": 1.34,
            "deg": 247,
            "gust": 4.47
          },
          "clouds": {
            "all": 0
          },
          "dt": 1624492769,
          "sys": {
            "type": 2,
            "id": 2007646,
            "country": "US",
            "sunrise": 1624452510,
            "sunset": 1624505715
          },
          "timezone": -25200,
          "id": 5391959,
          "name": "San Francisco",
          "cod": 200
        }
        """.data(using: .utf8)!
    
    let invalidJSONSanFran = """
                {
                  "coord": {
                    "lon": -122.4064,
                    "lat": 37.7858
                  },
                  "weather": [
                    {
                      "id": 800,
                      "main": "Clear",
                      "description": "clear sky",
                      "icon": "01d"
                    }
                  ],
                  "base": "stations",
                  "main": {
                    "temp": 293.22,
                    "feels_like": 293.19,
                    "temp_min": 289.32,
                    "temp_max": 300.94,
                    "pressure": 1014,
                    "humidity": 73
                  },
                  "visibility": 10000,
                  "wind": {
                    "speed": 1.34,
                    "deg": 247,
                    "gust": 4.47
                  },
                  "clouds": {
                    "all": 0
                  },
                  "dt": 1624492769,
                  "sys": {
                    "type": 2,
                    "id": =
                    "sunset": 1624505715
                  },
                  "timezone": -25200,
                  "id": 53919
                  "cod": 200
                }
                """.data(using: .utf8)!
    
//    func testDownloadingCurrentWeatherJSON() {
//        let client = NetworkManager()
//        let mockLoader = MockAPI(data: validJSONSanFran, error: .none)
//        let expectation = expectation(description: "Waiting for data")
//        client.fetchCurrentWeather(city: "San Francisco", using: mockLoader) { (weather) in
//            let wthr = weather
//            XCTAssertTrue(wthr.name != nil)
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 10)
//
//        }
//    }
    
    
    func testJSON() {
        
    }


}
