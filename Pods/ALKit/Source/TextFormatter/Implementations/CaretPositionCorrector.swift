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
//  CaretPositionCorrector.swift
//  ALAppCodesSwift
//
//  Created by Alirio-Lau on 2019/11/30.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import Foundation

class CaretPositionCorrector {
  let textPattern: String
  let patternSymbol: Character

  // MARK: - Life Cycle
  init(textPattern: String, patternSymbol: Character) {
    self.textPattern = textPattern
    self.patternSymbol = patternSymbol
  }

  func calculateCaretPositionOffset(originalRange range: NSRange, replacementFiltered: String) -> Int {
    var offset = 0
    if replacementFiltered.isEmpty {
      offset = offsetForRemove(current: range.location)
    } else {
      offset = offsetForInsert(from: range.location, replacementLength: replacementFiltered.count)
    }
    return offset
  }

  func indexesOfPatternSymbols(in searchRange: Range<String.Index>) -> [String.Index] {
    var indexes: [String.Index] = []
    var tempRange = searchRange
    while let range = textPattern.range(
      of: String(patternSymbol), options: .caseInsensitive, range: tempRange, locale: nil) {
        tempRange = range.upperBound..<tempRange.upperBound
        indexes.append(range.lowerBound)
    }
    return indexes
  }

  func offsetForRemove(current location: Int) -> Int {
    let startIndex = textPattern.startIndex
    let searchRange = startIndex..<textPattern.index(startIndex, offsetBy: location)
    let indexes = indexesOfPatternSymbols(in: searchRange)

    if let lastIndex = indexes.last {
      //return lastIndex.encodedOffset + 1
      return lastIndex.utf16Offset(in: textPattern) + 1
    }
    return 0
  }

  func offsetForInsert(from location: Int, replacementLength: Int) -> Int {
    let startIndex = textPattern.index(textPattern.startIndex, offsetBy: location)
    let searchRange = startIndex..<textPattern.endIndex
    let indexes = indexesOfPatternSymbols(in: searchRange)

    if replacementLength <= indexes.count {
      return textPattern.distance(from: textPattern.startIndex, to: indexes[replacementLength - 1]) + 1
    } else {
      return textPattern.distance(from: textPattern.startIndex, to: textPattern.endIndex)
    }
  }
}
