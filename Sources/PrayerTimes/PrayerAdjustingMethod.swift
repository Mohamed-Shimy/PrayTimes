//
//  PrayerAdjustingMethod.swift
//  iPray
//
//  Created by Mohamed Shemy on Sat 16 Apr, 2022.
//  Copyright © 2022 Mohamed Shemy. All rights reserved.
//

import Foundation

///
/// Adjusting Method for Higher Latitudes
///
public enum PrayerAdjustingMethod: Int {
    
    ///
    /// No adjustment
    ///
    case none = 0
    
    ///
    /// Middle night
    ///
    case midNight = 1
    
    ///
    /// 1/7th of night
    ///
    case oneSeventh = 2
    
    ///
    /// Angle/60th of night
    ///
    case angleBased = 3
}
