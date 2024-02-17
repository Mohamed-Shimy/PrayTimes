//
//  PrayingTimesConfigurable.swift
//  
//
//  Created by Mohamed Shemy on 16/02/2024.
//

import Foundation

public protocol PrayingTimesConfigurable {
    
    var timeZone: Double { get set }
    var location: PrayingTimeLocationCoordinate { get set }
    var calcMethod: PrayingTimeCalculationMethod { get set }
    var adjustHighLats: PrayingAdjustingMethod { get set }
    var timeFormat: PrayingTimeStyle { get set }
    var customParams: [Double]? { get set }
    var dhuhrMinutes: Double { get set }
    var juristic: PrayingJuristicMethod { get set }
    var daylightSavingsHours: Double { get set }
}
