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
//  Swizzler.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2020/1/18.
//  Copyright © 2020 com.alirio.lau.www. All rights reserved.
//

import Foundation

public struct Swizzler {

  public static func swizzleMethod(
    for sourceClass: AnyClass?,
    originalSelector: Selector,
    swizzledSelector: Selector
  ) {
    guard let originalMethod = class_getInstanceMethod(sourceClass, originalSelector),
      let swizzledMethod = class_getInstanceMethod(sourceClass, swizzledSelector) else {
        fatalError("Didn't find selector to swizzle")
    }

    let didAddMethod = class_addMethod(
      sourceClass,
      originalSelector,
      method_getImplementation(swizzledMethod),
      method_getTypeEncoding(swizzledMethod)
    )

    if didAddMethod {
      class_replaceMethod(
        sourceClass.self,
        swizzledSelector,
        method_getImplementation(originalMethod),
        method_getTypeEncoding(originalMethod)
      )
    } else {
      method_exchangeImplementations(originalMethod, swizzledMethod);
    }
  }

}
