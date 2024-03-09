//
//  PrayingTimeName.swift
//
//
//  Created by Mohamed Shemy on 09/03/2024.
//

import Foundation

public enum PrayingTimeName: Int, CaseIterable {
    
    case fajr
    case sunrise
    case dhuhr
    case asr
    case maghrib
    case isha
}

extension PrayingTimeName: Comparable {
    
    public static func < (lhs: PrayingTimeName, rhs: PrayingTimeName) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension PrayingTimeName {
    
    public subscript(index: Int) -> Self {
        Self.allCases[index]
    }
}
