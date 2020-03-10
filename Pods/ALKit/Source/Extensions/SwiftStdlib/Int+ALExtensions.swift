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
//  Int+ALExtensions.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2019/12/2.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import Foundation
import CoreGraphics

extension Int: ALCompatible { }

// MARK: - Properties

public extension ALWrapper where Base == Int {

  /// screen width ratio value
  var val: CGFloat {
    return CGFloat(base) * kWRatio
  }

  var countableRange: CountableRange<Int> {
    return 0..<base
  }

  var degreesToRadians: Double {
    return Double.pi * Double(base) / 180.0
  }

  var radiansToDegrees: Double {
    return Double(base) * 180 / Double.pi
  }

  var uInt: UInt {
    return UInt(base)
  }

  var double: Double {
    return Double(base)
  }

  var float: Float {
    return Float(base)
  }

  var cgFloat: CGFloat {
    return CGFloat(base)
  }

  /// String formatted for values over ±1000 (example: 1k, -2k, 100k, 1kk, -5kk..)
  var kFormatted: String {
    var sign: String {
      return base >= 0 ? "" : "-"
    }
    let abs = Swift.abs(base)
    if abs == 0 {
      return "0k"
    } else if abs >= 0 && abs < 1000 {
      return "0k"
    } else if abs >= 1000 && abs < 1000000 {
      return String(format: "\(sign)%ik", abs / 1000)
    }
    return String(format: "\(sign)%ikk", abs / 100000)
  }

  /// Array of digits of integer value.
  var digits: [Int] {
    guard base != 0 else { return [0] }
    var digits = [Int]()
    var number = base.abs

    while number != 0 {
      let xNumber = number % 10
      digits.append(xNumber)
      number /= 10
    }

    digits.reverse()
    return digits
  }

  /// Number of digits of integer value.
  var digitsCount: Int {
    guard base != 0 else { return 1 }
    let number = Double(base.abs)
    return Int(log10(number) + 1)
  }

}

// MARK: - Methods

public extension ALWrapper where Base == Int {

  /// check if given integer prime or not. Warning: Using big numbers can be computationally expensive!
  /// - Returns: true or false depending on prime-ness
  func isPrime() -> Bool {
    // To improve speed on latter loop :)
    if base == 2 { return true }

    guard base > 1 && base % 2 != 0 else { return false }

    // Explanation: It is enough to check numbers until
    // the square root of that number. If you go up from N by one,
    // other multiplier will go 1 down to get similar result
    // (integer-wise operation) such way increases speed of operation
    let base = Int(sqrt(Double(self.base)))
    for int in Swift.stride(from: 3, through: base, by: 2) where base % int == 0 {
      return false
    }
    return true
  }

  /// Roman numeral string from integer (if applicable).
  ///
  ///     10.romanNumeral() -> "X"
  ///
  /// - Returns: The roman numeral string.
  func romanNumeral() -> String? {
    // https://gist.github.com/kumo/a8e1cb1f4b7cff1548c7
    guard base > 0 else { // there is no roman numeral for 0 or negative numbers
      return nil
    }
    let romanValues = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
    let arabicValues = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]

    var romanValue = ""
    var startingValue = base

    for (index, romanChar) in romanValues.enumerated() {
      let arabicValue = arabicValues[index]
      let div = startingValue / arabicValue
      if div > 0 {
        for _ in 0..<div {
          romanValue += romanChar
        }
        startingValue -= arabicValue * div
      }
    }
    return romanValue
  }

  /// Rounds to the closest multiple of n
  func roundToNearest(_ number: Int) -> Int {
    return number == 0 ? base : Int(round(Double(base) / Double(number))) * number
  }

  // Array of bytes with optional padding (little-endian)
  func bytes(_ totalBytes: Int = MemoryLayout<Int>.size) -> [UInt8] {
    return arrayOfBytes(self, length: totalBytes)
  }
  
}

// array of bytes, little-endian representation
private func arrayOfBytes<T>(_ value: T, length: Int? = nil) -> [UInt8] {
  let totalBytes = length ?? (MemoryLayout<T>.size * 8)

  let valuePointer = UnsafeMutablePointer<T>.allocate(capacity: 1)
  valuePointer.pointee = value

  let bytes = valuePointer.withMemoryRebound(to: UInt8.self, capacity: totalBytes) { (bytesPointer) -> [UInt8] in
    var bytes = [UInt8](repeating: 0, count: totalBytes)
    for j in 0..<min(MemoryLayout<T>.size, totalBytes) {
      bytes[totalBytes - 1 - j] = (bytesPointer + j).pointee
    }
    return bytes
  }

  #if swift(>=4.1)
  valuePointer.deinitialize(count: 1)
  valuePointer.deallocate()
  #else
  valuePointer.deinitialize()
  valuePointer.deallocate(capacity: 1)
  #endif

  return bytes
}
