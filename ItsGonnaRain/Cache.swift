//
//  Cache.swift
//  WeatherApp
//
//  Created by Ezra Black on 6/23/21.
//  Copyright © 2021 Muhammad Osama Naeem. All rights reserved.
//

import UIKit
//could use this cache to make some things faster.
class Cache<Key: Hashable, Value> {
    
    func cache(value: Value, for key: Key) {
        queue.async {
            self.cache[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        return queue.sync { cache[key] }
    }
    
    func clear() {
        queue.async {
            self.cache.removeAll()
        }
    }
    
    private var cache = [Key : Value]()
    private let queue = DispatchQueue(label: "com.CasanovaStudios.ItsGonnaRain.CacheQueue")
}
