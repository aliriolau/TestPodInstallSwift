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
//  ALTextFormatter.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2019/12/9.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import Foundation

public class ALTextFormatter: NSObject {

  private let formatter: DefaultTextFormatter

  @objc public init(textPattern: String) {
    formatter = DefaultTextFormatter(textPattern: textPattern, patternSymbol: "#")
  }

  @objc public func format(_ unformattedText: String?) -> String? {
    return formatter.format(unformattedText)
  }

  @objc public func unformat(_ formatted: String?) -> String? {
    return formatter.unformat(formatted)
  }

}
