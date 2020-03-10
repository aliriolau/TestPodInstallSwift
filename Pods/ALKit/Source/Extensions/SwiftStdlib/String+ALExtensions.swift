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
//  String+ALExtensions.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2019/12/2.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import UIKit

public struct ALStringWrapper {
  public let base: String
  public init(_ base: String) {
    self.base = base
  }
}

public extension String {
  static var al: ALStringWrapper.Type {
    get { return ALStringWrapper.self }
    set { }
  }

  var al: ALStringWrapper {
    get { return ALStringWrapper(self) }
    set { }
  }
}

public extension ALStringWrapper {

  static func random(ofLength length: Int) -> String {
    guard length > 0 else { return "" }
    let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    var randomString = ""
    for _ in 1...length {
      randomString.append(base.randomElement()!)
    }
    return randomString
  }

}

// MARK: - Initializers

public extension String {

  /// Create a new string from a base64 string (if applicable).
  ///
  ///    String(base64: "SGVsbG8gV29ybGQh") = "Hello World!"
  ///    String(base64: "hello") = nil
  ///
  /// - Parameter base64: base64 string.
  init?(base64: String) {
    guard let decodedData = Data(base64Encoded: base64) else { return nil }
    guard let str = String(data: decodedData, encoding: .utf8) else { return nil }
    self.init(str)
  }

  /// Create a new random string of given length.
  ///
  ///    String(randomOfLength: 10) -> "gY8r3MHvlQ"
  ///
  /// - Parameter length: number of characters in string.
  init(randomOfLength length: Int) {
    guard length > 0 else {
      self.init()
      return
    }

    let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    var randomString = ""
    for _ in 1...length {
      randomString.append(base.randomElement()!)
    }
    self = randomString
  }

}

public extension String {

  /// Safely subscript string with index.
  ///
  ///    "Hello World!"[safe: 3] -> "l"
  ///    "Hello World!"[safe: 20] -> nil
  ///
  /// - Parameter index: index.
  subscript(safe index: Int) -> Character? {
    guard index >= 0 && index < count else { return nil }
    return self[self.index(startIndex, offsetBy: index)]
  }

  /// Safely subscript string within a half-open range.
  ///
  ///    "Hello World!"[safe: 6..<11] -> "World"
  ///    "Hello World!"[safe: 21..<110] -> nil
  ///
  /// - Parameter range: Half-open range.
  subscript(safe range: CountableRange<Int>) -> String? {
    guard let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex) else { return nil }
    guard let upperIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) else { return nil }
    return String(self[lowerIndex..<upperIndex])
  }

  /// Safely subscript string within a closed range.
  ///
  ///    "Hello World!"[safe: 6...11] -> "World!"
  ///    "Hello World!"[safe: 21...110] -> nil
  ///
  /// - Parameter range: Closed range.
  subscript(safe range: ClosedRange<Int>) -> String? {
    guard let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex) else { return nil }
    guard let upperIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) else { return nil }
    return String(self[lowerIndex...upperIndex])
  }
}

public extension String {

  @discardableResult
  mutating func reverse() -> String {
    let chars: [Character] = reversed()
    self = String(chars)
    return self
  }

  @discardableResult
  mutating func urlDecode() -> String {
    if let decoded = removingPercentEncoding {
      self = decoded
    }
    return self
  }

  @discardableResult
  mutating func urlEncode() -> String {
    if let encoded = addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
      self = encoded
    }
    return self
  }

  /// Slice given string from a start index with length (if applicable).
  ///
  ///    var str = "Hello World"
  ///    str.slice(from: 6, length: 5)
  ///    print(str) // prints "World"
  ///
  /// - Parameters:
  ///   - index: string index the slicing should start from.
  ///   - length: amount of characters to be sliced after given index.
  @discardableResult
  mutating func slice(from index: Int, length: Int) -> String {
    if let str = self.al.slicing(from: index, length: length) {
      self = String(str)
    }
    return self
  }

  /// Slice given string from a start index to an end index (if applicable).
  ///
  ///    var str = "Hello World"
  ///    str.slice(from: 6, to: 11)
  ///    print(str) // prints "World"
  ///
  /// - Parameters:
  ///   - start: string index the slicing should start from.
  ///   - end: string index the slicing should end at.
  @discardableResult
  mutating func slice(from start: Int, to end: Int) -> String {
    guard end >= start else { return self }
    if let str = self[safe: start..<end] {
      self = str
    }
    return self
  }

  /// Slice given string from a start index (if applicable).
  ///
  ///    var str = "Hello World"
  ///    str.slice(at: 6)
  ///    print(str) // prints "World"
  ///
  /// - Parameter index: string index the slicing should start from.
  @discardableResult
  mutating func slice(at index: Int) -> String {
    guard index < count else { return self }
    if let str = self[safe: index..<count] {
      self = str
    }
    return self
  }

}

// MARK: - Properties

public extension ALStringWrapper {

  /// String decoded from base64 (if applicable).
  ///
  ///    "SGVsbG8gV29ybGQh".base64Decoded = Optional("Hello World!")
  ///
  var base64Decoded: String? {
    // https://github.com/Reza-Rg/Base64-Swift-Extension/blob/master/Base64.swift
    guard let decodedData = Data(base64Encoded: base) else { return nil }
    return String(data: decodedData, encoding: .utf8)
  }

  /// String encoded in base64 (if applicable).
  ///
  ///    "Hello World!".base64Encoded -> Optional("SGVsbG8gV29ybGQh")
  ///
  var base64Encoded: String? {
    // https://github.com/Reza-Rg/Base64-Swift-Extension/blob/master/Base64.swift
    let plainData = base.data(using: .utf8)
    return plainData?.base64EncodedString()
  }

  var bool: Bool {
    base.al.nsString.boolValue
  }

  var md5: String {
    guard let data = base.data(using: .utf8) else {
      return base
    }

    let message = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
      return [UInt8](bytes)
    }

    let MD5Calculator = MD5(message)
    let MD5Data = MD5Calculator.calculate()

    var MD5String = String()
    for c in MD5Data {
      MD5String += String(format: "%02X", c)
    }
    return MD5String
  }

}

// MARK: - Methods

public extension ALStringWrapper {

  func trim(trimNewline: Bool = false) -> String {
    if trimNewline {
      return base.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    return base.trimmingCharacters(in: .whitespaces)
  }

  func replacingCharacters(in range: NSRange, with replacement: String) -> String {
    guard range.location <= base.count else { return base }
    let maxLength = base.count
    var limitedRange = NSRange(location: range.location, length: range.length)
    if range.location + range.length > maxLength {
      limitedRange.length = base.count - range.location
    }
    guard let swiftRange = Range(limitedRange, in: base) else { return base }
    return base.replacingCharacters(in: swiftRange, with: replacement)
  }

  func copyToPasteboard() {
    #if os(iOS)
    UIPasteboard.general.string = base
    #elseif os(macOS)
    NSPasteboard.general.clearContents()
    NSPasteboard.general.setString(base, forType: .string)
    #endif
  }

  func contains(_ string: String, caseSensitive: Bool = true) -> Bool {
    if !caseSensitive {
      return base.range(of: string, options: .caseInsensitive) != nil
    }
    return base.range(of: string) != nil
  }

  func date(withFormat format: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.date(from: base)
  }

  /// Sliced string from a start index with length.
  ///
  ///        "Hello World".slicing(from: 6, length: 5) -> "World"
  ///
  /// - Parameters:
  ///   - index: string index the slicing should start from.
  ///   - length: amount of characters to be sliced after given index.
  /// - Returns: sliced substring of length number of characters (if applicable) (example: "Hello World".slicing(from: 6, length: 5) -> "World")
  func slicing(from index: Int, length: Int) -> String? {
    guard length >= 0, index >= 0, index < base.count  else { return nil }
    guard index.advanced(by: length) <= base.count else {
      return base[safe: index..<base.count]
    }
    guard length > 0 else { return "" }
    return base[safe: index..<index.advanced(by: length)]
  }

  func index(of character: Character) -> Int {
    guard let index = base.firstIndex(of: character) else {
      return -1
    }
    return base.distance(from: base.startIndex, to: index)
  }

  func character(at index: Int) -> Character? {
    guard index < base.count else { return nil }
    return base[safe: index]
    //return base[base.index(base.startIndex, offsetBy: index)]
  }

  func substring(from index: Int) -> String {
    guard let value = base[safe: index..<base.count] else { return "" }
    return value
  }

  func substring(to index: Int) -> String {
    guard index <= base.count else { return "" }
    guard let value = base[safe: 0..<index] else { return "" }
    return value
  }

  func substring(to character: Character) -> String {
    let index: Int = self.index(of: character)
    guard index > -1 else { return "" }
    return substring(to: index)
  }

}

// MARK: - NSAttributedString

public extension ALStringWrapper {

  private typealias Font = UIFont

  var bold: NSAttributedString {
    return NSMutableAttributedString(string: base, attributes: [.font: Font.boldSystemFont(ofSize: Font.systemFontSize)])
  }

  var underline: NSAttributedString {
    return NSAttributedString(string: base, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
  }

  var strikethrough: NSAttributedString {
    return NSAttributedString(string: base, attributes: [.strikethroughStyle: NSNumber(value: NSUnderlineStyle.single.rawValue as Int)])
  }

  var italic: NSAttributedString {
    return NSMutableAttributedString(string: base, attributes: [.font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)])
  }

  func colored(with color: UIColor) -> NSAttributedString {
    return NSMutableAttributedString(string: base, attributes: [.foregroundColor: color])
  }

}

// MARK: - NSString extensions

public extension ALStringWrapper {

  var nsString: NSString {
    return NSString(string: base)
  }

  var lastPathComponent: String {
    return (base as NSString).lastPathComponent
  }

  var pathExtension: String {
    return (base as NSString).pathExtension
  }

  var deletingLastPathComponent: String {
    return (base as NSString).deletingLastPathComponent
  }

  var deletingPathExtension: String {
    return (base as NSString).deletingPathExtension
  }

  var pathComponents: [String] {
    return (base as NSString).pathComponents
  }

  /// NSString appendingPathComponent(str: String)
  ///
  /// - Note: This method only works with file paths (not, for example, string representations of URLs.
  ///   See NSString [appendingPathComponent(_:)](https://developer.apple.com/documentation/foundation/nsstring/1417069-appendingpathcomponent)
  /// - Parameter str: the path component to append to the receiver.
  /// - Returns: a new string made by appending aString to the receiver, preceded if necessary by a path separator.
  func appendingPathComponent(_ str: String) -> String {
    return (base as NSString).appendingPathComponent(str)
  }

  /// NSString appendingPathExtension(str: String)
  ///
  /// - Parameter str: The extension to append to the receiver.
  /// - Returns: a new string made by appending to the receiver an extension separator followed by ext (if applicable).
  func appendingPathExtension(_ str: String) -> String? {
    return (base as NSString).appendingPathExtension(str)
  }

}

// MARK: - Operators

public extension String {

  /// Repeat string multiple times.
  ///
  ///        'bar' * 3 -> "barbarbar"
  ///
  /// - Parameters:
  ///   - lhs: string to repeat.
  ///   - rhs: number of times to repeat character.
  /// - Returns: new string with given string repeated n times.
  static func * (lhs: String, rhs: Int) -> String {
    guard rhs > 0 else { return "" }
    return String(repeating: lhs, count: rhs)
  }

  /// Repeat string multiple times.
  ///
  ///        3 * 'bar' -> "barbarbar"
  ///
  /// - Parameters:
  ///   - lhs: number of times to repeat character.
  ///   - rhs: string to repeat.
  /// - Returns: new string with given string repeated n times.
  static func * (lhs: Int, rhs: String) -> String {
    guard lhs > 0 else { return "" }
    return String(repeating: rhs, count: lhs)
  }

}

private class MD5: HashProtocol {

  static let size = 16 // 128 / 8
  let message: [UInt8]

  init (_ message: [UInt8]) {
    self.message = message
  }

  // specifies the per-round shift amounts
  private let shifts: [UInt32] = [7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22,
                                  5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20,
                                  4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23,
                                  6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21]

  // binary integer part of the sines of integers (Radians)
  private let sines: [UInt32] = [0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee,
                                 0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501,
                                 0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be,
                                 0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821,
                                 0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa,
                                 0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8,
                                 0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed,
                                 0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a,
                                 0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c,
                                 0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70,
                                 0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x4881d05,
                                 0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665,
                                 0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039,
                                 0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1,
                                 0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1,
                                 0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391]

  private let hashes: [UInt32] = [0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476]

  func calculate() -> [UInt8] {
    var tmpMessage = prepare(64)
    tmpMessage.reserveCapacity(tmpMessage.count + 4)

    // hash values
    var hh = hashes

    // Step 2. Append Length a 64-bit representation of lengthInBits
    let lengthInBits = (message.count * 8)
    let lengthBytes = lengthInBits.al.bytes(64 / 8)
    tmpMessage += lengthBytes.reversed()

    // Process the message in successive 512-bit chunks:
    let chunkSizeBytes = 512 / 8 // 64

    for chunk in BytesSequence(chunkSize: chunkSizeBytes, data: tmpMessage) {
      // break chunk into sixteen 32-bit words M[j], 0 ≤ j ≤ 15
      let M = toUInt32Array(chunk)
      assert(M.count == 16, "Invalid array")

      // Initialize hash value for this chunk:
      var A: UInt32 = hh[0]
      var B: UInt32 = hh[1]
      var C: UInt32 = hh[2]
      var D: UInt32 = hh[3]

      var dTemp: UInt32 = 0

      // Main loop
      for j in 0 ..< sines.count {
        var g = 0
        var F: UInt32 = 0

        switch j {
        case 0...15:
          F = (B & C) | ((~B) & D)
          g = j
          break
        case 16...31:
          F = (D & B) | (~D & C)
          g = (5 * j + 1) % 16
          break
        case 32...47:
          F = B ^ C ^ D
          g = (3 * j + 5) % 16
          break
        case 48...63:
          F = C ^ (B | (~D))
          g = (7 * j) % 16
          break
        default:
          break
        }
        dTemp = D
        D = C
        C = B
        B = B &+ rotateLeft((A &+ F &+ sines[j] &+ M[g]), bits: shifts[j])
        A = dTemp
      }

      hh[0] = hh[0] &+ A
      hh[1] = hh[1] &+ B
      hh[2] = hh[2] &+ C
      hh[3] = hh[3] &+ D
    }
    var result = [UInt8]()
    result.reserveCapacity(hh.count / 4)

    hh.forEach {
      let itemLE = $0.littleEndian
      let r1 = UInt8(itemLE & 0xff)
      let r2 = UInt8((itemLE >> 8) & 0xff)
      let r3 = UInt8((itemLE >> 16) & 0xff)
      let r4 = UInt8((itemLE >> 24) & 0xff)
      result += [r1, r2, r3, r4]
    }
    return result
  }
}

private protocol HashProtocol {
  var message: [UInt8] { get }
  // Common part for hash calculation. Prepare header data.
  func prepare(_ len: Int) -> [UInt8]
}

private extension HashProtocol {

  func prepare(_ len: Int) -> [UInt8] {
    var tmpMessage = message

    // Step 1. Append Padding Bits
    tmpMessage.append(0x80) // append one bit (UInt8 with one bit) to message

    // append "0" bit until message length in bits ≡ 448 (mod 512)
    var msgLength = tmpMessage.count
    var counter = 0

    while msgLength % len != (len - 8) {
      counter += 1
      msgLength += 1
    }

    tmpMessage += [UInt8](repeating: 0, count: counter)
    return tmpMessage
  }
}

private struct BytesIterator: IteratorProtocol {

  let chunkSize: Int
  let data: [UInt8]

  init(chunkSize: Int, data: [UInt8]) {
    self.chunkSize = chunkSize
    self.data = data
  }

  var offset = 0

  mutating func next() -> ArraySlice<UInt8>? {
    let end = min(chunkSize, data.count - offset)
    let result = data[offset..<offset + end]
    offset += result.count
    return result.count > 0 ? result : nil
  }
}

private struct BytesSequence: Sequence {
  let chunkSize: Int
  let data: [UInt8]

  func makeIterator() -> BytesIterator {
    return BytesIterator(chunkSize: chunkSize, data: data)
  }
}

private func toUInt32Array(_ slice: ArraySlice<UInt8>) -> [UInt32] {
  var result = [UInt32]()
  result.reserveCapacity(16)

  for idx in stride(from: slice.startIndex, to: slice.endIndex, by: MemoryLayout<UInt32>.size) {
    let d0 = UInt32(slice[idx.advanced(by: 3)]) << 24
    let d1 = UInt32(slice[idx.advanced(by: 2)]) << 16
    let d2 = UInt32(slice[idx.advanced(by: 1)]) << 8
    let d3 = UInt32(slice[idx])
    let val: UInt32 = d0 | d1 | d2 | d3

    result.append(val)
  }
  return result
}

private func rotateLeft(_ value: UInt32, bits: UInt32) -> UInt32 {
  return ((value << bits) & 0xFFFFFFFF) | (value >> (32 - bits))
}
