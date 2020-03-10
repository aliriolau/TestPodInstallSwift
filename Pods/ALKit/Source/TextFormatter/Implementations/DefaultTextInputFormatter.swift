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
//  DefaultTextInputFormatter.swift
//  ALAppCodesSwift
//
//  Created by Alirio-Lau on 2019/11/30.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import Foundation

open class DefaultTextInputFormatter: DefaultTextFormatter, TextInputFormatter {

  private let caretPositionCorrector: CaretPositionCorrector

  // MARK: - Init
  public override init(
    textPattern: String,
    patternSymbol: Character = DefaultTextFormatter.Constants.defaultPatternSymbol) {
    self.caretPositionCorrector = CaretPositionCorrector(textPattern: textPattern, patternSymbol: patternSymbol)
    super.init(textPattern: textPattern, patternSymbol: patternSymbol)
  }

  // MARK: - open
  public func formatInput(_ currentText: String?, range: NSRange, replacementString text: String) -> FormattedTextValue {
    let unformattedRange = self.unformattedRange(from: range)
    let oldUnformattedText = (unformat(currentText) ?? "") as NSString

    let newText = oldUnformattedText.replacingCharacters(in: unformattedRange, with: text)
    let formattedText = self.format(newText) ?? ""

    let caretOffset = getCorrectedCaretPosition(range: range, replacementString: text)

    return FormattedTextValue(formattedText: formattedText, caretBeginOffset: caretOffset)
  }
}

// MARK: - Private
private extension DefaultTextInputFormatter {
  func correctedContent(currentContent: String?, range: NSRange, replacementFiltered: String) -> String? {
    let oldText = currentContent ?? String()

    let correctedRange = unformattedRange(from: range)
    let oldUnformatted = unformat(oldText) as NSString?

    let newText = oldUnformatted?.replacingCharacters(in: correctedRange, with: replacementFiltered)
    return format(newText)
  }

  func unformattedRange(from range: NSRange) -> NSRange {
    let newRange = NSRange(
      location: range.location - textPattern[..<textPattern.index(textPattern.startIndex, offsetBy: range.location)]
        .replacingOccurrences(of: String(patternSymbol), with: "").count,
      length: range.length - (textPattern as NSString).substring(with: range)
        .replacingOccurrences(of: String(patternSymbol), with: "").count)
    return newRange
  }

  // MARK: - Caret position calculation
  private func getCorrectedCaretPosition(range: NSRange, replacementString: String) -> Int {
    let offset = caretPositionCorrector.calculateCaretPositionOffset(originalRange: range, replacementFiltered: replacementString)
    return offset
  }
}
