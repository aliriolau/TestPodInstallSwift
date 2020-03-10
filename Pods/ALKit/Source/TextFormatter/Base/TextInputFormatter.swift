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
//  TextInputFormatter.swift
//  ALAppCodesSwift
//
//  Created by Alirio-Lau on 2019/11/30.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import Foundation

public struct FormattedTextValue: Equatable {
  public let formattedText: String
  public let caretBeginOffset: Int
}

/// Interface for formatter of TextInput, that allow change format of text during input
public protocol TextInputFormatter: TextFormatter {
  func formatInput(
    _ currentText: String?,
    range: NSRange,
    replacementString text: String
  ) -> FormattedTextValue
}
