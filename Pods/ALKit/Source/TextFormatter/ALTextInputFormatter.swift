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
//  ALTextInputFormatter.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2019/12/9.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import Foundation

public class ALFormattedTextValue: NSObject {
  @objc let formattedText: String
  @objc let caretBeginOffset: Int

  public init(_ formattedText: String, _ caretBeginOffset: Int) {
    self.formattedText = formattedText
    self.caretBeginOffset = caretBeginOffset;
  }
}

public class ALTextInputFormatter: ALTextFormatter {

  private let formatter: DefaultTextInputFormatter

  @objc public override init(textPattern: String) {
    formatter = DefaultTextInputFormatter(textPattern: textPattern, patternSymbol: "#")
    super.init(textPattern: textPattern)
  }

  @objc public func formatInput(_ currentText: String?, range: NSRange, replacementString text: String) -> ALFormattedTextValue {
    let result = formatter.formatInput(currentText, range: range, replacementString: text)
    let vaule = ALFormattedTextValue(result.formattedText, result.caretBeginOffset)
    return vaule
  }

}
