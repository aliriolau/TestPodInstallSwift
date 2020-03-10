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
//  ALKit.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2019/11/30.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import Foundation

public struct ALWrapper<Base> {
  public let base: Base
  public init(_ base: Base) {
    self.base = base
  }
}

public protocol ALCompatible {
  associatedtype ALWrapperValue
  static var al: ALWrapper<ALWrapperValue>.Type { get set }
  var al: ALWrapper<ALWrapperValue> { get set }
}

public extension ALCompatible {
  static var al: ALWrapper<Self>.Type {
    get { return ALWrapper<Self>.self }
    set { }
  }

  var al: ALWrapper<Self> {
    get { return ALWrapper(self) }
    set { }
  }
}
