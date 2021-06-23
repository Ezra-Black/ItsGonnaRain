//
//  Int+Ext.swift
//  ItsGonnaRain
//
//  Created by Ezra Black on 6/23/21.
//

import Foundation
//simple function to increment the work week without having to do the logic within the networking.
extension Int {
    func incrementWeekDays(by num: Int) -> Int {
        let incrementedVal = self + num
        let mod = incrementedVal % 7
        
        return mod
    }
}
