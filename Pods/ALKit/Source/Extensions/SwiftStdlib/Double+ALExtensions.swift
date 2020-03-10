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
//  Double+ALExtensions.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2019/12/2.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import Foundation
import CoreGraphics

extension Double: ALCompatible { }
public extension ALWrapper where Base == Double {

  /// screen width ratio value
  var val: CGFloat {
    return CGFloat(base) * kWRatio
  }
  
  var int: Int {
    return Int(base)
  }

  var float: Float {
    return Float(base)
  }

  var cgFloat: CGFloat {
    return CGFloat(base)
  }

}
