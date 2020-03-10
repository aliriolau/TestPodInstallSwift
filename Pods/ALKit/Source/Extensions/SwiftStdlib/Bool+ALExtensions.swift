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
//  Bool+ALExtensions.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2019/12/2.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import Foundation

extension Bool: ALCompatible { }
public extension ALWrapper where Base == Bool {

  var int: Int {
    return base ? 1 : 0
  }

  var string: String {
    return base ? "true" : "false"
  }

}
