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
//  DefaultTextFormatter.swift
//  ALAppCodesSwift
//
//  Created by Alirio-Lau on 2019/11/30.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import Foundation

// see: https://github.com/luximetr/AnyFormatKit

open class DefaultTextFormatter: TextFormatter {
  // MARK: - Fields

  /// String, example: patternSymbol - "#", format - "### (###) ###-##-##"
  public let textPattern: String

  /// Symbol that will be replace by input symbols
  public let patternSymbol: Character

  // MARK: - Init
  public init(
    textPattern: String,
    patternSymbol: Character = Constants.defaultPatternSymbol) {
    self.textPattern = textPattern
    self.patternSymbol = patternSymbol
  }

  // MARK: - TextFormatter
  open func format(_ unformattedText: String?) -> String? {
    guard let unformattedText = unformattedText else { return nil }
    var formatted = String.init()
    var unformattedIndex = 0
    var patternIndex = 0

    while patternIndex < textPattern.count && unformattedIndex < unformattedText.count {
      guard let patternCharacter = textPattern.al.character(at: patternIndex) else { break }
      if patternCharacter == patternSymbol {
        if let unformattedCharacter = unformattedText.al.character(at: unformattedIndex) {
          formatted.append(unformattedCharacter)
        }
        unformattedIndex += 1
      } else {
        formatted.append(patternCharacter)
      }
      patternIndex += 1
    }
    return formatted
  }

  /**
   Method for convert string, that sutisfy current textPattern, into unformatted string

   - Parameters:
   - formatted: String, that will convert

   - Returns: string converted into unformatted with current textPattern
   */
  open func unformat(_ formatted: String?) -> String? {
    guard let formatted = formatted else { return nil }
    var unformatted = String()
    var formattedIndex = 0

    while formattedIndex < formatted.count {
      if let formattedCharacter = formatted.al.character(at: formattedIndex) {
        if formattedIndex >= textPattern.count {
          unformatted.append(formattedCharacter)
        } else if formattedCharacter != textPattern.al.character(at: formattedIndex) {
          unformatted.append(formattedCharacter)
        }
        formattedIndex += 1
      }
    }
    return unformatted
  }

  public struct Constants {
    public static let defaultPatternSymbol: Character = "#"
  }
}
