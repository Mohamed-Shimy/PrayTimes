//
//  Configurations.swift
//  iPrayUI
//
//  Created by Mohamed Shemy on Wed 23 Dec 2020.
//  Copyright © 2020 Mohamed Shemy. All rights reserved.
//

import Foundation

open class PrayingTimesConfigurations: PrayingTimesConfigurable {
    
    open var timeZone: Double
    open var location: PrayingTimeLocationCoordinate
    open var calcMethod: PrayingTimeCalculationMethod
    open var adjustHighLats: PrayingAdjustingMethod
    open var timeFormat: PrayingTimeStyle
    open var customParams: [Double]? = nil
    open var dhuhrMinutes: Double = 0.0
    open var juristic: PrayingJuristicMethod
    open var daylightSavingsHours: Double
    
    public init(
        timeZone: Double,
        location: PrayingTimeLocationCoordinate,
        calcMethod: PrayingTimeCalculationMethod,
        adjustHighLats: PrayingAdjustingMethod,
        timeFormat: PrayingTimeStyle,
        customParams: [Double]? = nil,
        dhuhrMinutes: Double = 0.0,
        juristic: PrayingJuristicMethod,
        daylightSavingsHours: Double
    ) {
        self.timeZone = timeZone
        self.location = location
        self.calcMethod = calcMethod
        self.adjustHighLats = adjustHighLats
        self.timeFormat = timeFormat
        self.customParams = customParams
        self.dhuhrMinutes = dhuhrMinutes
        self.juristic = juristic
        self.daylightSavingsHours = daylightSavingsHours
    }
}
