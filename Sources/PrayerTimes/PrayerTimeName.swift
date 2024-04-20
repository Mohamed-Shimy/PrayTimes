//
//  PrayerTimeName.swift
//
//
//  Created by Mohamed Shemy on 09/03/2024.
//

import Foundation

public enum PrayerTimeName: Int, CaseIterable {
    
    case fajr
    case sunrise
    case dhuhr
    case asr
    case maghrib
    case isha
}

extension PrayerTimeName: Comparable {
    
    public static func < (lhs: PrayerTimeName, rhs: PrayerTimeName) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension PrayerTimeName {
    
    public subscript(index: Int) -> Self {
        Self.allCases[index]
    }
}
