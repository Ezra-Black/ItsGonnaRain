//
//  Date+Ext.swift
//  ItsGonnaRain
//
//  Created by Ezra Black on 6/23/21.
//

import Foundation

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
}
