//
//  Float+Ext.swift
//  ItsGonnaRain
//
//  Created by Ezra Black on 6/23/21.
//

import Foundation

extension Float {
    func truncate(places : Int)-> Float {
        return Float(floor(pow(10.0, Float(places)) * self)/pow(10.0, Float(places)))
    }
    
    func kelvinToFConverter() -> Float {
        let constantVal : Float = 273.15
        let kelValue            = self
        let celValue            = kelValue - constantVal
        let fValue              = (celValue * 1.8) + 32.00
        return fValue.truncate(places: 1)
    }
}

