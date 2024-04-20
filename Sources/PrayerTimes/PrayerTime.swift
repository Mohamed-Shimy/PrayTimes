//
//  PrayerTime.swift
//  PrayTimes
//
//  Created by Mohamed Shemy on 23 Oct, 2020.
//  Copyright © 2020 Mohamed Shemy. All rights reserved.
//

import Foundation

/// PrayerTime
///
/// Daily prayer (salah) times, fixed by Qur'an and Hadith,
/// are bound to the apparent motion of the Sun on the sky.
///
/// Zuhr prayer time enters when the Sun circle passes to the
/// west, Fajr prayer ends when the Sun starts to raise, Magrib
/// starts when the Sun sets completely.
/// Except Imam Abu Hanifa, Asr time starts when the shadow
/// elongates one object's length from its noon length (Asr-I).
/// Abu Hanifa rules that the shadow has to stretch two object's
/// length (Asr-II). It may be safer to complete Zuhr prayer before
/// Asr-I and perform the Asr after Asr-II; however in difficulty,
/// one may perform a missed Zuhr prayer until Asr-II without Qada
/// and then perform Asr prayer after Asr-II.
///
/// Fajr/Isha timings are predicated on the observation of the
/// onset/vanishing of the twilight on the horizon, which is dependent
/// both on the observer as well as the atmospheric conditions.
/// Therefore it cannot be determined precisely by computation.
/// Calculated timings are conjectural relying on certain assumptions,
/// which can vary for each country. If observation is not possible,
/// the indeterminate region should be taken into consideration, by
/// starting to fast before the Sun's vertical angle reaches -18º and
/// performing Fajr prayer after -15º. Similarly, Maghrib prayer should
/// be completed before -15º and Isha performed after -17º. Abu Hanifa
/// defines Isha as the end of the red glow on the sky, which occurs
/// between -9º and -12º. Considering this, it will be safer to finish
/// Maghrib prayer before -9º.
///
/// Prayer calendars may include a safety margin for each calculated timing,
/// which should be taken into account.
///
/// Daytime is coded as the fasting period, namely between Fajr and Maghrib
/// and the night as between Maghrib and Fajr.
///
/// Isha prayer should rather be completed before the first third of the night
/// or until midnight at most.
///
/// Because the eccentricity and obliquity of the Earth's motion, the Zuhr time
/// drifts 30 minutes within the year; so do the other timings since they are
/// calculated relative to Zuhr.
///
/// Prayer is not allowed when the Sun is near the horizon (elevation < 5°)
/// and its rays are yellowish.
///
/// Prayer is not allowed when the Sun is at highest.
/// Safe is not to pray after the center of the daytime
/// until Zuhr.
///
/// At high latitudes when the Isha enters very late,
/// it may be limited to one-third or one-half of the night.
/// Similarly, when the twilight persists, Fajr may be
/// limited to 30 minutes after the middle of sunset/sunrise
/// interval.
///
/// At higher latitudes when the Sun does not rise/set
/// or when the day/night periods are too small for prayer,
/// the timings may be fixed such that a convenient period
/// (45~60 minutes) is available for each prayer.
///
/// [Reference Alperen.com][spec]
///
/// [spec]:http://alperen.cepmuvakkit.com/alperen/makale/index.htm#Mekruh
///
/// [Reference PrayTimes.org][spec]
///
/// [spec]:http://praytimes.org
///
/// [Objective-C Source Code][spec]
///
/// [spec]:http://praytimes.org/code/git/?a=tree&p=PrayTimes&hb=HEAD&f=v1/objc
///
public struct PrayerTime: CustomStringConvertible {
    
    public typealias Location = PrayerTimeLocationCoordinate
    
    enum Index: Int {
        case fajr = 0
        case sunrise = 1
        case dhuhr = 2
        case asr = 3
        case sunset = 4
        case maghrib = 5
        case isha = 6
    }
    
    // MARK: - Private Properties
    
    ///
    /// Juristic method for Asr
    ///
    private var asrJuristic: PrayerJuristicMethod
    
    ///
    /// Minutes after mid-day for Dhuhr
    ///
    private var dhuhrMinutes = 0.0
    
    ///
    /// Calculation Method
    ///
    private var calcMethod: PrayerTimeCalculationMethod
    
    ///
    /// Adjusting method for higher latitudes
    ///
    private var adjustHighLats: PrayerAdjustingMethod
    
    ///
    /// Time Format
    ///
    private var timeFormat: PrayerTimeStyle
    
    ///
    /// Time Zone
    ///
    private var timeZone: Double = 0.0
    
    ///
    /// Julian date
    ///
    private var julianDate: Double = 0.0
    
    /// Pray times names
    ///
    ///      [0]: Fajr
    ///      [1]: Sunrise
    ///      [2]: Dhuhr
    ///      [3]: Asr
    ///      [4]: Maghrib
    ///      [5]: Isha
    ///
    static let timeNames = ["Fajr", "Sunrise", "Dhuhr", "Asr", "Maghrib", "Isha"]
    
    /// Method parameters
    ///
    ///  `methodParams`is a dictionary of `CalculationMethod` as a key
    ///   and array of `Double`  as a value
    ///
    private var methodParams: [PrayerTimeCalculationMethod : [Double]]
    
    ///
    /// Tuning offsets
    ///
    private var offsets: [Double]
    
    ///
    /// Pray Date
    ///
    private let date: Date
    
    ///
    /// Location
    ///
    private let location: Location
    
    // MARK: - Computed Properties
    
    /// Returns a string that describes the contents of the receiver.
    ///
    /// This method is used to create a textual representation of an object.
    ///
    public var description: String {
        var desc = ""
        let times = formattedTimes
        for (name, time) in zip(Self.timeNames, times) {
            desc += "\(name): \(time)\n"
        }
        return desc
    }
    
    ///
    /// Prayer times formatted for current date
    ///
    public var formattedTimes: [String] {
        adjustTimesFormat(times)
    }
    
    ///
    /// Prayer times for current date
    ///
    public var times: [Double] {
        var times = computeDayTimes()
        times.remove(at: Index.sunset.rawValue)
        return times
    }
    
    // MARK: - Init
    
    /// PrayerTime
    ///
    /// - Parameters:
    ///   - date: The value of PrayerDate with `day`, `month` and `year`.
    ///   - location: The value of  Location with `latitude` and  `longitude`.
    ///   - timeZone: The time zone value for the location.
    ///   - calcMethod: The method for times calculations, default `egypt`.
    ///   - adjustHighLats: The adjusting method for higher latitudes, default `midNight`.
    ///   - timeFormat: The time format, default `time12`.
    ///   - customParams: An optional array of `Double` for custom parameters.
    ///   - dhuhrMinutes: The value minutes after mid-day for Dhuhr, default `0.0`.
    ///   - asrJuristic: The juristic method, default `shafii`.
    ///
    public init(
        date: Date,
        location: Location,
        timeZone: Double,
        calcMethod: PrayerTimeCalculationMethod,
        adjustHighLats: PrayerAdjustingMethod,
        timeFormat: PrayerTimeStyle = .time12,
        customParams: [Double]? = nil,
        asrJuristic: PrayerJuristicMethod,
        dhuhrMinutes: Double = 0.0
    ) {
        self.date = date
        self.location = location
        self.calcMethod = calcMethod
        self.adjustHighLats = adjustHighLats
        self.timeFormat = timeFormat
        self.timeZone = timeZone
        self.dhuhrMinutes = dhuhrMinutes
        self.asrJuristic = asrJuristic
        
        //Tuning offsets
        offsets = [0, 0, 0, 0, 0, 0, 0]
        methodParams = PrayerTimeCalculationMethod.allCases.reduce([:]) { result, method in
            var result = result
            result[method] = method.values
            return result
        }
        
        let lonDiff = location.longitude / 336.0 // 336.0 = (15.0 * 24.0)
        julianDate = julianDate(from: date) - lonDiff
        
        if let customParams = customParams, !customParams.isEmpty {
            setCustomParams(customParams)
        }
    }
    
    /// PrayerTime
    ///
    /// - Parameters:
    ///   - configurations: the Prayer time configurations.
    ///   - date: The value of PrayerDate with `day`, `month` and `year`.
    ///
    public init(configurations: PrayerTimesConfigurable, date: Date) {
        self.init(
            date: date,
            location: configurations.location,
            timeZone: configurations.timeZone + configurations.daylightSavingsHours,
            calcMethod: configurations.calcMethod,
            adjustHighLats: configurations.adjustHighLats,
            timeFormat: configurations.timeFormat,
            customParams: configurations.customParams,
            asrJuristic: configurations.juristic,
            dhuhrMinutes: configurations.dhuhrMinutes
        )
    }
    
    /// The difference between two times
    ///
    /// Compute the difference between two times
    ///
    /// - Parameters:
    ///   - time1: The first value.
    ///   - time2: The secound value.
    ///
    /// - Returns:
    ///   - The difference between two `time2` and `time1`.
    ///
    private func timeDiff(_ time1: Double, _ time2: Double) -> Double {
        return fixhour(time2 - time1)
    }
    
    /// Set custom values for calculation parameters
    ///
    /// - Parameters:
    ///   - params: array of `Double` for custome parameters .
    ///
    private mutating func setCustomParams(_ params: [Double]) {
        var cust = methodParams[.custom]!
        let cal = methodParams[calcMethod]!
        for i in 0..<5 {
            cust[i] = params[i] == -1 ? cal[i] : params[i]
        }
        calcMethod = .custom
    }
    
    /// Convert double hours to 24h format
    ///
    ///     float time = hours + (minutes / 60)
    ///
    ///     hours = Intergar value
    ///     minutes = reminder * 60
    ///
    ///     ex: float time 17.25
    ///         hours = 17
    ///         minutes = 0.25 * 60 = 15
    ///
    ///     let time = time24(from: 17.25)
    ///     // time == "17:15"
    ///
    /// - Parameters:
    ///   - float: The value of hours.
    ///
    /// - Returns:
    ///   - Formated hours to 24h format.
    ///
    private func time24(from float: Double) -> String {
        var time = float
        if time.isNaN { return "" }
        
        time = fixhour((time + 0.5 / 60.0)) // add 0.5 minutes to round
        let hours = floor(time)
        let minutes = floor((time - hours) * 60.0)
        
        return String(format: "%02d:%02.0f", hours, minutes)
    }
    
    /// Cconvert double hours to 12h format
    ///
    ///     let time = time12(from: 17.25, with: false)
    ///     // time == "5:15 pm"
    ///
    ///     let timeNS = time12(from: 17.25, with: true)
    ///     // timeNS == "5:15"
    ///
    /// - Parameters:
    ///   - time: The value of hours.
    ///   - noSuffix: The flag for no suffix in output format.
    ///
    /// - Returns:
    ///   - Formated hours to 12h format.
    ///
    private func time12(from float: Double) -> String {
        var time = float
        if time.isNaN { return "" }
        
        time = fixhour((time + 0.5 / 60)) // add 0.5 minutes to round
        var hours = floor(time)
        let minutes = floor((time - hours) * 60)
        
        hours = (hours + 12) - 1
        var hrs = Int(hours) % 12
        hrs += 1
        
        return String(format: "%02d:%02.0f", hrs, minutes)
    }
    
    /// Set the angle for calculating Fajr
    ///
    /// - Parameters:
    ///     - angle: The angle for calculating Fajr
    ///
    mutating func setFajr(angle param: Double) {
        let params: [Double] = [param, -1, -1, -1, -1]
        setCustomParams(params)
    }
    
    /// Set the angle for calculating Maghrib
    ///
    /// - Parameters:
    ///     - angle: The angle for calculating Maghrib
    ///
    mutating func setMaghrib(angle param: Double) {
        let params: [Double] = [-1, 0, param, -1, -1]
        setCustomParams(params)
    }
    
    /// Set the angle for calculating Isha
    ///
    /// - Parameters:
    ///     - angle: The angle for calculating Isha
    ///
    mutating func setIsha(angle param: Double) {
        let params: [Double] = [-1, -1, -1, 0, param]
        setCustomParams(params)
    }
    
    /// Set the minutes after Sunset for calculating Maghrib
    ///
    /// - Parameters:
    ///     - minutes: The minutes after Sunset
    ///
    mutating func setMaghrib(minutes param: Double) {
        let params: [Double] = [-1, -1, param, -1, -1]
        setCustomParams(params)
    }
    
    /// Set the minutes after Maghrib for calculating Isha
    ///
    /// - Parameters:
    ///     - minutes: The minutes after Maghrib
    ///
    mutating func setIsha(minutes param: Double) {
        let params: [Double] = [-1, -1, -1, -1, param]
        setCustomParams(params)
    }
}

// MARK: - Sun Position Calculations -
extension PrayerTime {
    
    /// Compute declination angle of sun and equation of time
    ///
    /// - Parameters:
    ///     - julianDate: Date for     calculations
    ///
    /// - Returns:
    ///   - Declination angle of sun and equation of time
    ///
    ///                 [0]: Declination angle of sun
    ///                 [1]: Equation of time
    ///
    private func sunPosition(_ julianDate : Double) -> [Double] {
        let date = julianDate - 2451545
        let meanAnomaly = fixangle(357.529 + 0.98560028 * date)
        let meanLongitude = fixangle(280.459 + 0.98564736 * date)
        let eclipticAngle = fixangle(meanLongitude + (1.915 * dsin(meanAnomaly)) + (0.020 * dsin(2 * meanAnomaly)))
        
        let obliquityofEarth = 23.439 - (0.00000036 * date)
        let declination = darcsin(dsin(obliquityofEarth) * dsin(eclipticAngle))
        var rightAscension = (darctan2((dcos(obliquityofEarth) * dsin(eclipticAngle)), andX: dcos(eclipticAngle))) / 15.0
        rightAscension = fixhour(rightAscension)
        
        let timeEquation = meanLongitude / 15.0 - rightAscension
        
        return [declination, timeEquation]
    }
    
    /// Compute equation of time
    ///
    /// - Parameters:
    ///     - julianDate: Date for calculations
    ///
    /// - Returns:
    ///   - Equation of time
    ///
    private func equationOfTime(_ julianDate: Double) -> Double {
        return sunPosition(julianDate)[1]
    }
    
    /// Compute declination angle of sun
    ///
    /// - Parameters:
    ///     - julianDate: Date for calculations
    ///
    /// - Returns:
    ///   - Declination angle of sun
    ///
    private func sunDeclination(_ julianDate: Double) -> Double {
        return sunPosition(julianDate)[0]
    }
    
    /// Compute mid-day (Dhuhr, Zawal) time
    ///
    /// - Parameters:
    ///     - time: time value
    ///
    /// - Returns:
    ///   - Mid-day (Zawal) time
    ///
    private func computeMidDay(_ time: Double) -> Double {
        let time = equationOfTime(julianDate + time)
        let zawal = fixhour(12 - time)
        return zawal
    }
    
    /// Compute time for a given angle G
    ///
    ///- Parameters:
    ///     - angle: Time angle
    ///     - time: time value
    ///
    private func computeTime(_ angle: Double, andTime time: Double) -> Double {
        let D = sunDeclination(julianDate + time)
        let zawal = computeMidDay(time)
        let V = (darccos((-dsin(angle) - (dsin(D) * dsin(location.latitude))) / (dcos(D) * dcos(location.latitude)))) / 15.0
        
        return zawal + (angle > 90 ? -V : V)
    }
    
    /// Compute the time of Asr
    ///
    /// Shafii: step=1, Hanafi: step=2
    ///
    private func computeAsr(_ step: Double, andTime time: Double) -> Double {
        let d = sunDeclination(julianDate + time)
        let g = -darccot(step + dtan(abs(location.latitude - d)))
        return computeTime(g, andTime: time)
    }
}

// MARK: - Julian Date -
extension PrayerTime {
    
    /// Calculate julian date from a pray date
    ///
    /// - Parameters:
    ///     - prayDate: `PrayDate` value
    ///
    /// - Returns:
    ///   - Julian date
    ///
    private func julianDate(from prayDate: Date) -> Double {
        let date1970 = 2440587.5
        let julianDate = date1970 + prayDate.timeIntervalSince1970 / 86400
        return julianDate
    }
    
    /// Convert a calendar date to julian date
    ///
    /// - Parameters:
    ///     - year: Year value
    ///     - month: Month value
    ///     - day: Day value
    ///
    /// - Returns:
    ///   - Julian date
    ///
    private func julianDate(from year: Int, andMonth month: Int, andDay day: Int) -> Double {
        let date1970: Double = 2440588
        var components = DateComponents()
        components.weekday = day
        
        components.month = month
        components.year = year
        let gregorian = Calendar(identifier: .gregorian)
        let date1 = gregorian.date(from: components)
        
        let milliseconds = date1?.timeIntervalSince1970 ?? 0.0 // # of milliseconds since midnight Jan 1, 1970
        let days = floor(milliseconds / 86400000) // 86400000 = 1000.0 * 60.0 * 60.0 * 24.0
        let result = date1970 + days - 0.5
        return result
    }
}

// MARK: - Compute Prayer Times -
extension PrayerTime {
    
    /// Compute prayer times at given julian date
    ///
    /// - Parameters:
    ///     - times : Date times values
    ///
    /// - Returns:
    ///   - Given date pray times values
    ///
    private func computeTimes(_ times: [Double]) -> [Double] {
        let times = dayPortion(times)
        let methodParam = methodParams[calcMethod]!
        let idk = methodParam[0]
        let fajr = computeTime((180 - idk), andTime: times[.fajr])
        let sunrise = computeTime((180 - 0.833), andTime: times[.sunrise])
        let dhuhr = computeMidDay(times[.dhuhr])
        let asr = computeAsr(Double(asrJuristic.rawValue), andTime: times[.asr])
        let sunset = computeTime(0.833, andTime: times[.sunset])
        let maghrib = computeTime(methodParams[calcMethod]![2], andTime: times[.maghrib])
        let isha = computeTime((methodParams[calcMethod]![4]), andTime: times[.isha])
        
        return [fajr, sunrise, dhuhr, asr, sunset, maghrib, isha]
    }
    
    /// Compute prayer times for current day
    ///
    /// - Returns:
    ///    - Formated current day pray times
    ///
    private func computeDayTimes() -> [Double] {
        let times: [Double] = [5, 6, 12, 13, 18, 18, 18]
        let computedTimes = computeTimes(times)
        let adjustedTimes = adjustTimes(computedTimes)
        let tuneTimesdTimes = tuneTimes(adjustedTimes)
        return tuneTimesdTimes
    }
    
    ///
    /// Tune Times
    ///
    private func tuneTimes(_ times: [Double]) -> [Double] {
        var off: Double
        var time: Double
        var times = times
        for i in 0..<times.count {
            off = offsets[i] / 60.0
            time = times[i] + off
            times[i] = time
        }
        return times
    }
    
    ///
    /// Adjust times in a prayer time array
    ///
    private func adjustTimes(_ times: [Double]) -> [Double] {
        var times = times
        var a: [Double] = []
        var time: Double = 0
        var Dtime: Double
        let Dtime1: Double
        let Dtime2: Double
        
        for i in 0..<times.count {
            time = times[i] + (timeZone - location.longitude / 15.0)
            times[i] = time
        }
        
        Dtime = times[.dhuhr] + (dhuhrMinutes / 60.0) //Dhuhr
        times[.dhuhr] = Dtime
        
        a = methodParams[calcMethod]!
        let val = a[1]
        
        if val == 1 {
            // Maghrib
            Dtime1 = times[.sunset] + methodParams[calcMethod]![2]
            times[.maghrib] = Dtime1
        }
        
        if methodParams[calcMethod]![3] == 1 {
            // Isha
            Dtime2 = times[.maghrib] + (methodParams[calcMethod]![4] / 60.0)
            times[.isha] = Dtime2
        }
        
        if adjustHighLats != .none {
            times = adjustHighLatTimes(times)
        }
        return times
    }
    
    ///
    /// Convert times array to given time format
    ///
    private func adjustTimesFormat(_ times: [Double]) -> [String] {
        return times.map({ formatedTime(for: $0) })
    }
    
    private func formatedTime(for time: Double) -> String {
        switch timeFormat {
            case .time12, .time12NS: return time12(from: time)
            case .time24, .float: return time24(from: time)
        }
    }
    
    ///
    /// Adjust Fajr, Isha and Maghrib for locations in higher latitudes
    ///
    private func adjustHighLatTimes(_ times: [Double]) -> [Double] {
        var times = times
        let time0 = times[.fajr]
        let time1 = times[.sunrise]
        let time4 = times[.sunset]
        let time5 = times[.maghrib]
        let time6 = times[.isha]
        
        let nightTime = timeDiff(time4, time1) // sunset to sunrise
        
        // Adjust Fajr
        let obj0 = methodParams[calcMethod]![0]
        let obj1 = methodParams[calcMethod]![1]
        let obj2 = methodParams[calcMethod]![2]
        let obj3 = methodParams[calcMethod]![3]
        let obj4 = methodParams[calcMethod]![4]
        
        let FajrDiff: Double = nightPortion(obj0) * nightTime
        
        if (time0.isNaN) || (timeDiff(time0, time1) > FajrDiff) {
            times[0] = time1 - FajrDiff
        }
        
        // Adjust Isha
        let IshaAngle: Double = (obj3 == 0) ? obj4 : 18
        let IshaDiff: Double = nightPortion(IshaAngle) * nightTime
        if time6.isNaN || timeDiff(time4, time6) > IshaDiff {
            times[6] = time4 + IshaDiff
        }
        
        // Adjust Maghrib
        let MaghribAngle: Double = (obj1 == 0) ? obj2 : 4
        let MaghribDiff: Double = nightPortion(MaghribAngle) * nightTime
        if time5.isNaN || timeDiff(time4, time5) > MaghribDiff {
            times[5] = time4 + MaghribDiff
        }
        return times
    }
    
    ///
    /// The night portion used for adjusting times in higher latitudes
    ///
    private func nightPortion(_ angle: Double) -> Double {
        var calc = 0.0
        switch adjustHighLats {
            case .none: calc = 0.0
            case .midNight: calc = 0.5
            case .oneSeventh: calc = 0.14286
            case .angleBased: calc = angle / 60.0
        }
        return calc
    }
    
    ///
    /// Convert hours to day portions
    ///
    private func dayPortion(_ times: [Double]) -> [Double] {
        var times = times
        var time: Double = 0
        for i in 0..<times.count {
            time = times[i]
            time = time / 24.0
            times[i] = time
        }
        return times
    }
}

// MARK: - Trigonometric Functions -
extension PrayerTime {
    
    ///
    /// Range reduce angle in degrees.
    ///
    private func fixangle(_ a: Double) -> Double {
        var a = a
        a = a - (360 * (floor(a / 360.0)))
        a = a < 0 ? (a + 360) : a
        return a
    }
    
    ///
    /// Range reduce hours to 0..23
    ///
    private func fixhour(_ a: Double) -> Double {
        var a = a
        a = a - 24.0 * floor(a / 24.0)
        a = a < 0 ? (a + 24) : a
        return a
    }
    
    ///
    /// Radian to degree
    ///
    private func radians(toDegrees alpha: Double) -> Double {
        return (alpha * 180.0) / .pi
    }
    
    ///
    /// Deree to radian
    ///
    private func degrees(toRadians alpha: Double) -> Double {
        return (alpha * .pi) / 180.0
    }
    
    ///
    /// Degree sin
    ///
    private func dsin(_ d: Double) -> Double {
        return sin(degrees(toRadians: d))
    }
    
    ///
    /// Degree cos
    ///
    private func dcos(_ d: Double) -> Double {
        return cos(degrees(toRadians: d))
    }
    
    ///
    /// Degree tan
    ///
    private func dtan(_ d: Double) -> Double {
        return tan(degrees(toRadians: d))
    }
    
    ///
    /// Degree arcsin
    ///
    private func darcsin(_ x: Double) -> Double {
        let val = asin(x)
        return radians(toDegrees: val)
    }
    
    ///
    /// Degree arccos
    ///
    private func darccos(_ x: Double) -> Double {
        let val = acos(x)
        return radians(toDegrees: val)
    }
    
    ///
    /// Degree arctan
    ///
    private func darctan(_ x: Double) -> Double {
        let val = atan(x)
        return radians(toDegrees: val)
    }
    
    ///
    /// Degree arctan2
    ///
    private func darctan2(_ y: Double, andX x: Double) -> Double {
        let val = atan2(y, x)
        return radians(toDegrees: val)
    }
    
    ///
    /// Degree arccot
    ///
    private func darccot(_ x: Double) -> Double {
        let val = atan2(1.0, x)
        return radians(toDegrees: val)
    }
}

fileprivate extension Array where Element == Double {
    
    subscript(_ index: PrayerTime.Index) -> Double {
        get { self[index.rawValue] }
        set { self[index.rawValue] = newValue }
    }
}
