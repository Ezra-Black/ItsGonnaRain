//
//  MockAPI.swift
//  WeatherApp
//
//  Created by Ezra Black on 6/23/21.
//  Copyright © 2021 Muhammad Osama Naeem. All rights reserved.
//

import Foundation

class MockAPI: NetworkDataLoader {
    let data: Data?
    let error: Error?
    init(data: Data?, error: Error?) {
        self.data = data
        self.error = error
    }
    
    func loadData(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        DispatchQueue.global().async {
            completion(self.data, self.error)
        }
    }
    
    func loadData(from url: URL, completion: @escaping (Data?, Error?) -> Void) {
            completion(self.data, self.error)
    }
}
