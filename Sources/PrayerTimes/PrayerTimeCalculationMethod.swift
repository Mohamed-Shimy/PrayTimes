//
//  PrayerTimeCalculationMethod.swift
//  iPray
//
//  Created by Mohamed Shemy on Sat 16 Apr, 2022.
//  Copyright © 2022 Mohamed Shemy. All rights reserved.
//

import Foundation

///
/// Calculation Method
///
public enum PrayerTimeCalculationMethod: Int {
    
    ///
    /// University of Islamic Sciences, Karachi
    ///
    case karachi = 1
    
    ///
    /// Islamic Society of North America (ISNA)
    ///
    case isna = 2
    
    ///
    /// Muslim World League (MWL)
    ///
    case mwl = 3
    
    ///
    /// Umm al-Qura, Makkah
    ///
    case makkah = 4
    
    ///
    /// Egyptian General Authority of Survey
    ///
    case egypt = 5
    
    ///
    /// Institute of Geophysics, University of Tehran
    ///
    case tehran = 6
    
    ///
    /// Custom Setting
    ///
    case custom = 0
}

extension PrayerTimeCalculationMethod {
    
    public var values: [Double] {
        switch self {
            case .karachi: return [18, 1, 0, 0, 18]
            case .isna: return [15, 1, 0, 0, 15]
            case .mwl: return [18, 1, 0, 0, 17]
            case .makkah: return [18.5, 1, 0, 1, 90]
            case .egypt: return [19.5, 1, 0, 0, 17.5]
            case .tehran: return [17.7, 0, 4.5, 0, 14]
            case .custom: return [18, 1, 0, 0, 17]
        }
    }
}

extension PrayerTimeCalculationMethod: CaseIterable {
    
    static var allMethod: [PrayerTimeCalculationMethod] {
        var all = allCases
        all.removeAll { $0 == .custom }
        return all
    }
}
