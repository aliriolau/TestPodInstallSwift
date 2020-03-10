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
//  SignedNumeric+ALExtensions.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2019/12/2.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import Foundation

// MARK: - Properties
public extension SignedNumeric {

  /// String.
  var string: String {
    return String(describing: self)
  }

  #if canImport(Foundation)
  /// String with number and current locale currency.
  var asLocaleCurrency: String? {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.locale = Locale.current
    // swiftlint:disable:next force_cast
    return formatter.string(from: self as! NSNumber)
  }
  #endif

}

// MARK: - Methods
public extension SignedNumeric {

  #if canImport(Foundation)
  /// Spelled out representation of a number.
  ///
  ///        print((12.32).spelledOutString()) // prints "twelve point three two"
  ///
  /// - Parameter locale: Locale, default is .current.
  /// - Returns: String representation of number spelled in specified locale language. E.g. input 92, output in "en": "ninety-two"
  func spelledOutString(locale: Locale = .current) -> String? {
    let formatter = NumberFormatter()
    formatter.locale = locale
    formatter.numberStyle = .spellOut

    guard let number = self as? NSNumber else { return nil }
    return formatter.string(from: number)
  }
  #endif

}
