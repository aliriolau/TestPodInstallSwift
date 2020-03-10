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
//  CGRect+ALExtension.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2019/12/19.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGRect {

  init(x: CGFloat, y: CGFloat, size: CGSize) {
    self.init(x: x, y: y, width: size.width, height: size.height)
  }
  
}
