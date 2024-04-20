//
//  PrayerTimesConfigurable.swift
//  
//
//  Created by Mohamed Shemy on 16/02/2024.
//

import Foundation

public protocol PrayerTimesConfigurable {
    
    var timeZone: Double { get set }
    var location: PrayerTimeLocationCoordinate { get set }
    var calcMethod: PrayerTimeCalculationMethod { get set }
    var adjustHighLats: PrayerAdjustingMethod { get set }
    var timeFormat: PrayerTimeStyle { get set }
    var customParams: [Double]? { get set }
    var dhuhrMinutes: Double { get set }
    var juristic: PrayerJuristicMethod { get set }
    var daylightSavingsHours: Double { get set }
}
