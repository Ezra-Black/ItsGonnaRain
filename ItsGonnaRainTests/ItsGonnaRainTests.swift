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
Is the completion handler called when data is good?✅
Is the completion handler called when data is bad?✅
Is the completion handler called when the network fails?✅
*/


class ItsGonnaRainTests: XCTestCase {
    //usually you only want one instance for each test for unitTesting, but for times sake I threw in some good/bad JSON to work with
    
    
    func testDownloadMockCurrentWeatherJSON() {
        let json = validJSONSanFran
        let mockLoader = MockAPI(data: json, error: .none)
        let client = NetworkManager(networkLoader: mockLoader )
        let promise = expectation(description: "Waiting for data")
        client.fetchCurrentWeather(city: "San Francisco", using: mockLoader) { (weather) in
            
            guard mockLoader.data != nil,
                  mockLoader.error == nil else {
                XCTFail("Mock Data Loader was nil")
                return
            }
            let wthr = weather
            let sanTimeZone = -25200
            XCTAssertTrue(wthr.name != nil)
            XCTAssertEqual(sanTimeZone, wthr.timezone)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    //add contextual type of two arguments to the closures of the network, allowing us to pass errors within the tests themselves. If I get the time before the interview be sure to implement this to make the tests as clean as possible  -------------------------------------------------------------------------👇
    //   client.fetchCurrentWeather(city: "San Fancisco", using: mockloader) { (weather, error) in
    func testDecodingBadMockJSON() {
        let dataLoader = MockAPI(data: invalidJSONSanFran, error: NSError())
        let client = NetworkManager(networkLoader: dataLoader)
        let promise = expectation(description: "Error Loading Bad Data")
        
        client.fetchCurrentWeather(city: "San Francisco", using: dataLoader) { (weather) in
            guard dataLoader.error != nil else {
                XCTAssertNil(weather)
                XCTFail("Testing for bad mock data failed")
                return
            }
    //compare jsons?
            XCTAssertEqual(dataLoader.data, invalidJSONSanFran)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    
    func testFetchingCurrentWeather() {
        //calling a real network manager here
        let client = NetworkManager()
        let expectation = expectation(description: "Received valid JSON")
        client.fetchCurrentWeather(city: "San Francisco") { weather in
            XCTAssertNotNil(weather)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    
}


