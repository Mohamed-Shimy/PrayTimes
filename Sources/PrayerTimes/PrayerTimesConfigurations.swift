//
//  Configurations.swift
//  iPrayUI
//
//  Created by Mohamed Shemy on Wed 23 Dec 2020.
//  Copyright © 2020 Mohamed Shemy. All rights reserved.
//

import Foundation

open class PrayerTimesConfigurations: PrayerTimesConfigurable {
    
    open var timeZone: Double
    open var location: PrayerTimeLocationCoordinate
    open var calcMethod: PrayerTimeCalculationMethod
    open var adjustHighLats: PrayerAdjustingMethod
    open var timeFormat: PrayerTimeStyle
    open var customParams: [Double]? = nil
    open var dhuhrMinutes: Double = 0.0
    open var juristic: PrayerJuristicMethod
    open var daylightSavingsHours: Double
    
    public init(
        timeZone: Double,
        location: PrayerTimeLocationCoordinate,
        calcMethod: PrayerTimeCalculationMethod,
        adjustHighLats: PrayerAdjustingMethod,
        timeFormat: PrayerTimeStyle,
        customParams: [Double]? = nil,
        dhuhrMinutes: Double = 0.0,
        juristic: PrayerJuristicMethod,
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
