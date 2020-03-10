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
//  TextFormatter.swift
//  ALAppCodesSwift
//
//  Created by Alirio-Lau on 2019/11/30.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import Foundation

public protocol TextFormatter {
  func format(_ unformattedText: String?) -> String?
  func unformat(_ formattedText: String?) -> String?
}
