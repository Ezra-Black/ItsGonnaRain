//
//  MockJSON.swift
//  ItsGonnaRain
//
//  Created by Ezra Black on 7/05/21.
//

import Foundation
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
            awefawwgwg  3.19,
                "tempwef_min": 289.32,
                "tempawefa_max": 300.94,
                "preswefasure": 1014,
                "humiwefdity": 73
              },
              "visibilasdfaewfweity": 10000,
              "wind": {
                "speed": 1.34,
                "deg": 247,
                "gusawefaweft": 4.47
              },
              "clouds": {
                "all": 0
              },
              "dt":awefawef 1624492769,
              "sys": {
                "type": 2,
                "id": =
                "sawefawefawefunset": 1624505715
              },awefwef
              "tiawefawefawemezone": -25200,
              "id": 53919
              "cod": 200
            awefawefawefwf }
            """.data(using: .utf8)!
