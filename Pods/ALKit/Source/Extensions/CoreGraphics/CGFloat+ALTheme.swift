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
//  CGFloat+ALTheme.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2019/11/30.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import UIKit

extension CGFloat: ALCompatible { }
public extension ALWrapper where Base == CGFloat {
  var val: CGFloat {
    return base * kWRatio
  }

  var abs: CGFloat {
    return Swift.abs(base)
  }

  #if canImport(Foundation)
  var ceil: CGFloat {
    return Foundation.ceil(base)
  }

  var floor: CGFloat {
    return Foundation.floor(base)
  }
  #endif

  var isPositive: Bool {
    return base > 0
  }

  var isNegative: Bool {
    return base < 0
  }

  var int: Int {
    return Int(base)
  }

  var float: Float {
    return Float(base)
  }

  var double: Double {
    return Double(base)
  }

  var degreesToRadians: CGFloat {
    return .pi * base / 180.0
  }

  var radiansToDegrees: CGFloat {
    return base * 180 / CGFloat.pi
  }

}
