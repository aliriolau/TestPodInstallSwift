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
//  ObjC+NSObject.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2019/12/26.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import Foundation

// defined in `@objc` protocols would be available for ObjC message, sending via `AnyObject`.
@objc public protocol ObjCNSObject {
  // An alias for `-class`, which is unavailable in Swift.
  @objc(class)
  var objcClass: AnyClass! { get }

  @objc(instancesRespondToSelector:)
  static func instancesRespond(to selector: Selector) -> Bool

  @objc(methodForSelector:)
  func method(for selector: Selector) -> Method
}
