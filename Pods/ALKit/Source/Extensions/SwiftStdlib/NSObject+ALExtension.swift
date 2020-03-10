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
//  NSObject+ALExtension.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2019/12/25.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import Foundation

extension ALWrapper where Base: NSObjectProtocol {

  /// The class of the instance reported by the ObjC `-class:` message.
  ///
  /// - note: `type(of:)` might return the runtime subclass, while this property
  ///         always returns the original class.
  // @nonobjc
  var `class`: AnyClass {
    return (base as AnyObject).objcClass
  }

  func methodSignature(for selector: Selector) -> MethodSignature? {
    guard let method = class_getInstanceMethod(self.class, selector),
      let objCTypes = method_getTypeEncoding(method) else {
        return nil
    }

    let methodSignature = MethodSignature(objCTypes: objCTypes)

    return methodSignature
  }

  func invocation(for selector: Selector) -> Invocation? {
    guard let method = class_getInstanceMethod(self.class, selector),
      let objCTypes = method_getTypeEncoding(method) else {
        return nil
    }

    let methodSignature = MethodSignature(objCTypes: objCTypes)
    let invocation = Invocation(methodSignature: methodSignature)
    invocation.target = base
    invocation.selector = selector

    return invocation
  }

  func invocation(for methodSignature: MethodSignature) -> Invocation {
    let invocation = Invocation(methodSignature: methodSignature)

    return invocation
  }

}
