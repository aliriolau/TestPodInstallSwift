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
//  Character+ALExtensions.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2019/12/2.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import Foundation

public struct ALCharacterWrapper {
  public let base: Character
  init(_ base: Character) {
    self.base = base
  }
}

public extension Character {
  static var al: ALCharacterWrapper.Type {
    get { return ALCharacterWrapper.self }
    set { }
  }

  var al: ALCharacterWrapper {
    get { return ALCharacterWrapper(self) }
    set { }
  }
}

public extension ALCharacterWrapper {

  // MARK: - Properties

  var isChinese: Bool {
    base <= "\u{9FA5}" && base >= "\u{4E00}"
  }

  /// Check if character is emoji.
  ///
  ///        Character("😀").isEmoji -> true
  ///
  var isEmoji: Bool {
    // http://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
    let scalarValue = String(base).unicodeScalars.first!.value
    switch scalarValue {
    case 0x1F600...0x1F64F, // Emoticons
    0x1F300...0x1F5FF, // Misc Symbols and Pictographs
    0x1F680...0x1F6FF, // Transport and Map
    0x1F1E6...0x1F1FF, // Regional country flags
    0x2600...0x26FF, // Misc symbols
    0x2700...0x27BF, // Dingbats
    0xE0020...0xE007F, // Tags
    0xFE00...0xFE0F, // Variation Selectors
    0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
    127000...127600, // Various asian characters
    65024...65039, // Variation selector
    9100...9300, // Misc items
    8400...8447: // Combining Diacritical Marks for Symbols
      return true
    default:
      return false
    }
  }

  /// Integer from character (if applicable).
  ///
  ///        Character("1").int -> 1
  ///        Character("A").int -> nil
  ///
  var int: Int? {
    return Int(String(base))
  }

  /// String from character.
  ///
  ///        Character("a").string -> "a"
  ///
  var string: String {
    return String(base)
  }

  /// Return the character lowercased.
  ///
  ///        Character("A").lowercased -> Character("a")
  ///
  var lowercased: Character {
    return String(base).lowercased().first!
  }

  /// Return the character uppercased.
  ///
  ///        Character("a").uppercased -> Character("A")
  ///
  var uppercased: Character {
    return String(base).uppercased().first!
  }

}

// MARK: - Methods

public extension ALCharacterWrapper {

  /// Random character.
  ///
  ///    Character.random() -> k
  ///
  /// - Returns: A random character.
  static func randomAlphanumeric() -> Character {
    return "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".randomElement()!
  }

}

public extension Character {

  /// Repeat character multiple times.
  ///
  ///        Character("-") * 10 -> "----------"
  ///
  /// - Parameters:
  ///   - lhs: character to repeat.
  ///   - rhs: number of times to repeat character.
  /// - Returns: string with character repeated n times.
  static func * (lhs: Character, rhs: Int) -> String {
    guard rhs > 0 else { return "" }
    return String(repeating: String(lhs), count: rhs)
  }

  /// Repeat character multiple times.
  ///
  ///        10 * Character("-") -> "----------"
  ///
  /// - Parameters:
  ///   - lhs: number of times to repeat character.
  ///   - rhs: character to repeat.
  /// - Returns: string with character repeated n times.
  static func * (lhs: Int, rhs: Character) -> String {
    guard lhs > 0 else { return "" }
    return String(repeating: String(rhs), count: lhs)
  }

}
