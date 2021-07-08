//
//  ItsGonnaRainTests.swift
//  ItsGonnaRainTests
//
//  Created by Ezra Black on 7/05/21.
//

import XCTest
@testable import ItsGonnaRain

class ItsGonnaRainTests: XCTestCase {
    
    var calendar: NSCalendar?
    var locale: NSLocale?
    
    override func setUp() {
        super.setUp()
        
        calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)
        locale = NSLocale(localeIdentifier: "en_US")
    }
    
    func testAsynchronousURLConnection() {
        let URL = NSURL(string: "https://openweathermap.org/")!
        let expectation = expectation(description: "GET \(URL)")
        
        let session = URLSession.shared
        let task = session.dataTask(with: URL as URL) { data, response, error in
            XCTAssertNotNil(data, "data should not be nil")
            XCTAssertNil(error, "error should be nil")
            
            if let HTTPResponse = response as? HTTPURLResponse,
               let responseURL = HTTPResponse.url,
               let response = HTTPResponse.mimeType
            {
                XCTAssertEqual(responseURL.absoluteString, URL.absoluteString, "HTTP response URL should be equal to original URL")
                XCTAssertEqual(HTTPResponse.statusCode, 200, "HTTP response status code should be 200")
                XCTAssertEqual(response, "text/html", "HTTP response content type should be text/html")
            } else {
                XCTFail("Response was not HTTPURLResponse")
            }
            
            expectation.fulfill()
        }
        
        task.resume()
        
        waitForExpectations(timeout: task.originalRequest!.timeoutInterval) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            task.cancel()
        }
    }
    
    func testDownloadMockCurrentWeatherJSON() {
        let json = validJSONSanFran
        let mockLoader = MockAPI(data: json, error: .none)
        let sut = NetworkManager(networkLoader: mockLoader )
        let promise = expectation(description: "Waiting for data")
        sut.fetchCurrentWeather(city: "San Francisco", using: mockLoader) { (weather) in
            
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
    
    func testDecodingBadMockJSON() {
        let dataLoader = MockAPI(data: invalidJSONSanFran, error: NSError())
        let sut = NetworkManager(networkLoader: dataLoader)
        let promise = expectation(description: "Error Loading Bad Data")
        
        sut.fetchCurrentWeather(city: "San Francisco", using: dataLoader) { (weather) in
            guard dataLoader.error != nil else {
                XCTAssertNil(weather)
                XCTFail("Testing for bad mock data failed")
                return
            }
            XCTAssertEqual(dataLoader.data, invalidJSONSanFran)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    
    func testFetchingLiveCurrentWeather() {
        let sut = NetworkManager()
        let expectation = expectation(description: "Received valid JSON")
        sut.fetchCurrentWeather(city: "San Francisco") { weather in
            XCTAssertNotNil(weather)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchingLocationWeather() {
        let sut = NetworkManager()
        let expectation = expectation(description: "location fetch success")
        sut.fetchCurrentLocationWeather(lat: "38.58362662029875", lon: "-90.02905025910329") { weather in
            XCTAssertNotNil(weather)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
}


