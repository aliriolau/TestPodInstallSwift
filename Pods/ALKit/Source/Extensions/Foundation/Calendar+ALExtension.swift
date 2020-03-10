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
//  Calendar+ALExtension.swift
//  ALAppCodesSwift
//
//  Created by Alirio-Lau on 2019/12/1.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import Foundation

extension Calendar: ALCompatible {}
public extension ALWrapper where Base == Calendar {

  /// Return the number of days in the month for a specified 'Date'.
  ///
  ///    let date = Date() // "Jan 12, 2017, 7:07 PM"
  ///    Calendar.current.numberOfDaysInMonth(for: date) -> 31
  ///
  /// - Parameter date: the date form which the number of days in month is calculated.
  /// - Returns: The number of days in the month of 'Date'.
  func numberOfDaysInMonth(for date: Date) -> Int {
    return base.range(of: .day, in: .month, for: date)!.count
  }
}
