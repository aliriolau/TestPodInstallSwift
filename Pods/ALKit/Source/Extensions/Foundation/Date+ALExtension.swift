//
//                            Open Your Mind!
//
//                  .-~~~~~~~~~-._       _.-~~~~~~~~~-.
//              __.'              ~.   .~              `.__
//            .'//                  \./                  \\`.
//          .'//                     |                     \\`.
//        .'// .-~"""""""~~~~-._     |     _,-~~~~"""""""~-. \\`.
//      .'//.-"                 `-.  |  .-'                 "-.\\`.
//    .'//______.============-..   \ | /   ..-============.______\\`.
//  .'______________________________\|/______________________________`.
//
//  Date+ALExtension.swift
//  ALAppCodesSwift
//
//  Created by Alirio-Lau on 2019/12/1.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import Foundation
import Darwin

public struct ALDateWrapper {
  public var base: Date
  init(_ base: Date) {
    self.base = base
  }
}

public extension Date {
  static var al: ALDateWrapper.Type {
    get { return ALDateWrapper.self }
    set { }
  }

  var al: ALDateWrapper {
    get { return ALDateWrapper(self) }
    set { }
  }
}

// MARK: - Initializers
public extension Date {

  /// Create a new date form calendar components.
  ///
  ///   let date = Date(year: 2010, month: 1, day: 12) // "Jan 12, 2010, 7:45 PM"
  ///
  /// - Parameters:
  ///   - calendar: Calendar (default is current).
  ///   - timeZone: TimeZone (default is current).
  ///   - era: Era (default is current era).
  ///   - year: Year (default is current year).
  ///   - month: Month (default is current month).
  ///   - day: Day (default is today).
  ///   - hour: Hour (default is current hour).
  ///   - minute: Minute (default is current minute).
  ///   - second: Second (default is current second).
  ///   - nanosecond: Nanosecond (default is current nanosecond).
  init?(
    calendar: Calendar? = Calendar.current,
    timeZone: TimeZone? = NSTimeZone.default,
    era: Int? = Date().al.era,
    year: Int? = Date().al.year,
    month: Int? = Date().al.month,
    day: Int? = Date().al.day,
    hour: Int? = Date().al.hour,
    minute: Int? = Date().al.minute,
    second: Int? = Date().al.second,
    nanosecond: Int? = Date().al.nanosecond) {

    var components = DateComponents()
    components.calendar = calendar
    components.timeZone = timeZone
    components.era = era
    components.year = year
    components.month = month
    components.day = day
    components.hour = hour
    components.minute = minute
    components.second = second
    components.nanosecond = nanosecond

    guard let date = calendar?.date(from: components) else { return nil }
    self = date
  }

  /// Create date object from ISO8601 string.
  ///
  ///   let date = Date(iso8601String: "2017-01-12T16:48:00.959Z") // "Jan 12, 2017, 7:48 PM"
  ///
  /// - Parameter iso8601String: ISO8601 string of format (yyyy-MM-dd'T'HH:mm:ss.SSSZ).
  init?(iso8601String: String) {
    // https://github.com/justinmakaila/NSDate-ISO-8601/blob/master/NSDateISO8601.swift
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    guard let date = dateFormatter.date(from: iso8601String) else { return nil }
    self = date
  }

  /// Create new date object from UNIX timestamp.
  ///
  ///   let date = Date(unixTimestamp: 1484239783.922743) // "Jan 12, 2017, 7:49 PM"
  ///
  /// - Parameter unixTimestamp: UNIX timestamp.
  init(unixTimestamp: Double) {
    self.init(timeIntervalSince1970: unixTimestamp)
  }

}

public extension ALDateWrapper {

  /// Returns a random date within the specified range.
  ///
  /// - Parameter range: The range in which to create a random date. `range` must not be empty.
  /// - Returns: A random date within the bounds of `range`.
  static func random(in range: Range<Date>) -> Date {
    return Date(timeIntervalSinceReferenceDate:
      TimeInterval.random(in: range.lowerBound.timeIntervalSinceReferenceDate..<range.upperBound.timeIntervalSinceReferenceDate))
  }

  /// Returns a random date within the specified range.
  ///
  /// - Parameter range: The range in which to create a random date.
  /// - Returns: A random date within the bounds of `range`.
  static func random(in range: ClosedRange<Date>) -> Date {
    return Date(timeIntervalSinceReferenceDate:
      TimeInterval.random(in: range.lowerBound.timeIntervalSinceReferenceDate...range.upperBound.timeIntervalSinceReferenceDate))
  }

  /// Returns a random date within the specified range, using the given generator as a source for randomness.
  ///
  /// - Parameters:
  ///   - range: The range in which to create a random date. `range` must not be empty.
  ///   - generator: The random number generator to use when creating the new random date.
  /// - Returns: A random date within the bounds of `range`.
  static func random<T>(in range: Range<Date>, using generator: inout T) -> Date where T: RandomNumberGenerator {
    return Date(timeIntervalSinceReferenceDate:
      TimeInterval.random(in: range.lowerBound.timeIntervalSinceReferenceDate..<range.upperBound.timeIntervalSinceReferenceDate,
                          using: &generator))
  }

  /// Returns a random date within the specified range, using the given generator as a source for randomness.
  ///
  /// - Parameters:
  ///   - range: The range in which to create a random date.
  ///   - generator: The random number generator to use when creating the new random date.
  /// - Returns: A random date within the bounds of `range`.
  static func random<T>(in range: ClosedRange<Date>, using generator: inout T) -> Date where T: RandomNumberGenerator {
    return Date(timeIntervalSinceReferenceDate:
      TimeInterval.random(in: range.lowerBound.timeIntervalSinceReferenceDate...range.upperBound.timeIntervalSinceReferenceDate,
                          using: &generator))
  }
  
}

// MARK: - Properties

public extension ALDateWrapper {

  var calendar: Calendar {
    // Workaround to segfault on corelibs foundation https://bugs.swift.org/browse/SR-10147
    return Calendar(identifier: Calendar.current.identifier)
  }

  /// Era.
  ///
  ///    Date().era -> 1
  ///
  var era: Int {
    return calendar.component(.era, from: base)
  }

  var weekOfYear: Int {
    return calendar.component(.weekOfYear, from: base)
  }

  var weekOfMonth: Int {
    return calendar.component(.weekOfMonth, from: base)
  }

  /// Year.
  ///
  ///    Date().year -> 2017
  ///
  ///    var someDate = Date()
  ///    someDate.year = 2000 // sets someDate's year to 2000
  ///
  var year: Int {
    get { return calendar.component(.year, from: base) }
    set {
      guard newValue > 0 else { return }
      let currentYear = calendar.component(.year, from: base)
      let yearsToAdd = newValue - currentYear
      if let date = calendar.date(byAdding: .year, value: yearsToAdd, to: base) {
        base = date
      }
    }
  }

  /// Month.
  ///
  ///   Date().month -> 1
  ///
  ///   var someDate = Date()
  ///   someDate.month = 10 // sets someDate's month to 10.
  ///
  var month: Int {
    get { return calendar.component(.month, from: base) }
    set {
      let allowedRange = calendar.range(of: .month, in: .year, for: base)!
      guard allowedRange.contains(newValue) else { return }

      let currentMonth = calendar.component(.month, from: base)
      let monthsToAdd = newValue - currentMonth
      if let date = calendar.date(byAdding: .month, value: monthsToAdd, to: base) {
        base = date
      }
    }
  }

  /// Day.
  ///
  ///   Date().day -> 12
  ///
  ///   var someDate = Date()
  ///   someDate.day = 1 // sets someDate's day of month to 1.
  ///
  var day: Int {
    get { return calendar.component(.day, from: base) }
    set {
      let allowedRange = calendar.range(of: .day, in: .month, for: base)!
      guard allowedRange.contains(newValue) else { return }

      let currentDay = calendar.component(.day, from: base)
      let daysToAdd = newValue - currentDay
      if let date = calendar.date(byAdding: .day, value: daysToAdd, to: base) {
        base = date
      }
    }
  }

  /// Hour.
  ///
  ///   Date().hour -> 17 // 5 pm
  ///
  ///   var someDate = Date()
  ///   someDate.hour = 13 // sets someDate's hour to 1 pm.
  ///
  var hour: Int {
    get { return calendar.component(.hour, from: base) }
    set {
      let allowedRange = calendar.range(of: .hour, in: .day, for: base)!
      guard allowedRange.contains(newValue) else { return }

      let currentHour = calendar.component(.hour, from: base)
      let hoursToAdd = newValue - currentHour
      if let date = calendar.date(byAdding: .hour, value: hoursToAdd, to: base) {
        base = date
      }
    }
  }

  /// Minutes.
  ///
  ///   Date().minute -> 39
  ///
  ///   var someDate = Date()
  ///   someDate.minute = 10 // sets someDate's minutes to 10.
  ///
  var minute: Int {
    get { return calendar.component(.minute, from: base) }
    set {
      let allowedRange = calendar.range(of: .minute, in: .hour, for: base)!
      guard allowedRange.contains(newValue) else { return }

      let currentMinutes = calendar.component(.minute, from: base)
      let minutesToAdd = newValue - currentMinutes
      if let date = calendar.date(byAdding: .minute, value: minutesToAdd, to: base) {
        base = date
      }
    }
  }

  /// Seconds.
  ///
  ///   Date().second -> 55
  ///
  ///   var someDate = Date()
  ///   someDate.second = 15 // sets someDate's seconds to 15.
  ///
  var second: Int {
    get { return calendar.component(.second, from: base) }
    set {
      let allowedRange = calendar.range(of: .second, in: .minute, for: base)!
      guard allowedRange.contains(newValue) else { return }

      let currentSeconds = calendar.component(.second, from: base)
      let secondsToAdd = newValue - currentSeconds
      if let date = calendar.date(byAdding: .second, value: secondsToAdd, to: base) {
        base = date
      }
    }
  }

  /// Nanoseconds.
  ///
  ///   Date().nanosecond -> 981379985
  ///
  ///   var someDate = Date()
  ///   someDate.nanosecond = 981379985 // sets someDate's seconds to 981379985.
  ///
  var nanosecond: Int {
    get { return calendar.component(.nanosecond, from: base) }
    set {
      #if targetEnvironment(macCatalyst)
      // The `Calendar` implementation in `macCatalyst` does not know that a nanosecond is 1/1,000,000,000th of a second
      let allowedRange = 0..<1_000_000_000
      #else
      let allowedRange = calendar.range(of: .nanosecond, in: .second, for: base)!
      #endif
      guard allowedRange.contains(newValue) else { return }

      let currentNanoseconds = calendar.component(.nanosecond, from: base)
      let nanosecondsToAdd = newValue - currentNanoseconds

      if let date = calendar.date(byAdding: .nanosecond, value: nanosecondsToAdd, to: base) {
        base = date
      }
    }
  }

  /// Milliseconds.
  ///
  ///   Date().millisecond -> 68
  ///
  ///   var someDate = Date()
  ///   someDate.millisecond = 68 // sets someDate's nanosecond to 68000000.
  ///
  var millisecond: Int {
    get { return calendar.component(.nanosecond, from: base) / 1_000_000 }
    set {
      let nanoSeconds = newValue * 1_000_000
      #if targetEnvironment(macCatalyst)
      // The `Calendar` implementation in `macCatalyst` does not know that a nanosecond is 1/1,000,000,000th of a second
      let allowedRange = 0..<1_000_000_000
      #else
      let allowedRange = calendar.range(of: .nanosecond, in: .second, for: base)!
      #endif
      guard allowedRange.contains(nanoSeconds) else { return }

      if let date = calendar.date(bySetting: .nanosecond, value: nanoSeconds, of: base) {
        base = date
      }
    }
  }

  /// Check if date is in future.
  ///
  ///   Date(timeInterval: 100, since: Date()).isInFuture -> true
  ///
  var isInFuture: Bool {
    return base > Date()
  }

  /// Check if date is in past.
  ///
  ///   Date(timeInterval: -100, since: Date()).isInPast -> true
  ///
  var isInPast: Bool {
    return base < Date()
  }

  /// Check if date is within today.
  ///
  ///   Date().isInToday -> true
  ///
  var isInToday: Bool {
    return calendar.isDateInToday(base)
  }

  /// Check if date is within yesterday.
  ///
  ///   Date().isInYesterday -> false
  ///
  var isInYesterday: Bool {
    return calendar.isDateInYesterday(base)
  }

  /// Check if date is within tomorrow.
  ///
  ///   Date().isInTomorrow -> false
  ///
  var isInTomorrow: Bool {
    return calendar.isDateInTomorrow(base)
  }

  /// Check if date is within a weekend period.
  var isInWeekend: Bool {
    return calendar.isDateInWeekend(base)
  }

  /// Check if date is within a weekday period.
  var isWorkday: Bool {
    return !calendar.isDateInWeekend(base)
  }

  /// Check if date is within the current week.
  var isInCurrentWeek: Bool {
    return calendar.isDate(base, equalTo: Date(), toGranularity: .weekOfYear)
  }

  /// Check if date is within the current month.
  var isInCurrentMonth: Bool {
    return calendar.isDate(base, equalTo: Date(), toGranularity: .month)
  }

  /// Check if date is within the current year.
  var isInCurrentYear: Bool {
    return calendar.isDate(base, equalTo: Date(), toGranularity: .year)
  }

  var yesterday: Date {
    return calendar.date(byAdding: .day, value: -1, to: base) ?? Date()
  }

  var tomorrow: Date {
    return calendar.date(byAdding: .day, value: 1, to: base) ?? Date()
  }

  var unixTimestamp: Double {
    return base.timeIntervalSince1970
  }

}

// MARK: - Methods

public extension ALDateWrapper {

  func string(withFormat format: String = "yyyy-MM-dd HH:mm:ss") -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: base)
  }

  /// Date string from date.
  ///
  ///   Date().dateString(ofStyle: .short) -> "1/12/17"
  ///   Date().dateString(ofStyle: .medium) -> "Jan 12, 2017"
  ///   Date().dateString(ofStyle: .long) -> "January 12, 2017"
  ///   Date().dateString(ofStyle: .full) -> "Thursday, January 12, 2017"
  ///
  /// - Parameter style: DateFormatter style (default is .medium).
  /// - Returns: date string.
  func dateString(ofStyle style: DateFormatter.Style = .medium) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = .none
    dateFormatter.dateStyle = style
    return dateFormatter.string(from: base)
  }

  /// Date and time string from date.
  ///
  ///   Date().dateTimeString(ofStyle: .short) -> "1/12/17, 7:32 PM"
  ///   Date().dateTimeString(ofStyle: .medium) -> "Jan 12, 2017, 7:32:00 PM"
  ///   Date().dateTimeString(ofStyle: .long) -> "January 12, 2017 at 7:32:00 PM GMT+3"
  ///   Date().dateTimeString(ofStyle: .full) -> "Thursday, January 12, 2017 at 7:32:00 PM GMT+03:00"
  ///
  /// - Parameter style: DateFormatter style (default is .medium).
  /// - Returns: date and time string.
  func dateTimeString(ofStyle style: DateFormatter.Style = .medium) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = style
    dateFormatter.dateStyle = style
    return dateFormatter.string(from: base)
  }

  /// Time string from date
  ///
  ///   Date().timeString(ofStyle: .short) -> "7:37 PM"
  ///   Date().timeString(ofStyle: .medium) -> "7:37:02 PM"
  ///   Date().timeString(ofStyle: .long) -> "7:37:02 PM GMT+3"
  ///   Date().timeString(ofStyle: .full) -> "7:37:02 PM GMT+03:00"
  ///
  /// - Parameter style: DateFormatter style (default is .medium).
  /// - Returns: time string.
  func timeString(ofStyle style: DateFormatter.Style = .medium) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = style
    dateFormatter.dateStyle = .none
    return dateFormatter.string(from: base)
  }

  func secondsSince(_ date: Date) -> Double {
    return base.timeIntervalSince(date)
  }

  func minutesSince(_ date: Date) -> Double {
    return base.timeIntervalSince(date)/60
  }

  func hoursSince(_ date: Date) -> Double {
    return base.timeIntervalSince(date)/3600
  }

  func daysSince(_ date: Date) -> Double {
    return base.timeIntervalSince(date)/(3600*24)
  }

  func isBetween(
    _ startDate: Date,
    _ endDate: Date,
    includeBounds: Bool = false
  ) -> Bool {
    if includeBounds {
      return startDate.compare(base).rawValue * base.compare(endDate).rawValue >= 0
    }
    return startDate.compare(base).rawValue * base.compare(endDate).rawValue > 0
  }

  func isWithin(
    _ value: UInt,
    _ component: Calendar.Component,
    of date: Date
  ) -> Bool {
    let components = calendar.dateComponents([component], from: base, to: date)
    let componentValue = components.value(for: component)!
    return Swift.abs(componentValue) <= value
  }

}
