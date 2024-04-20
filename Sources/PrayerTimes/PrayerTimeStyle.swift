//
//  PrayerTimeStyle.swift
//  iPray
//
//  Created by Mohamed Shemy on Sat 16 Apr, 2022.
//  Copyright © 2022 Mohamed Shemy. All rights reserved.
//

import Foundation

///
/// Time Format
///
public enum PrayerTimeStyle: Int {
    
    /// 24-hour format
    ///
    ///     example:
    ///         17:15
    ///
    case time24 = 1
    
    /// 12-hour format
    ///
    ///     example:
    ///         5:14 pm
    ///
    case time12 = 2
    
    /// 12-hour format with no suffix
    ///
    ///     example:
    ///         5:15
    ///
    case time12NS = 3
    
    /// Floating punumber
    ///
    ///     example:
    ///         17.25
    ///
    case float = 4
}
