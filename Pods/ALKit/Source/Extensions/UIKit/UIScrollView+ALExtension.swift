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
//  UIScrollView+ALExtension.swift
//  ALAppCodesSwift
//
//  Created by Alirio-Lau on 2019/12/1.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import UIKit

public extension ALWrapper where Base: UIScrollView {

  var screenshot: UIImage? {
    UIGraphicsBeginImageContextWithOptions(base.contentSize, false, 0)
    defer { UIGraphicsEndImageContext() }
    guard let context = UIGraphicsGetCurrentContext() else { return nil }
    let previousFrame = base.frame
    base.frame = CGRect(origin: base.frame.origin, size: base.contentSize)
    base.layer.render(in: context)
    base.frame = previousFrame
    return UIGraphicsGetImageFromCurrentImageContext()
  }
  
}
