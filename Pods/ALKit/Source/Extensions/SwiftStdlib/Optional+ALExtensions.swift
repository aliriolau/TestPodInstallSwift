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
//  Optional+ALExtensions.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2020/2/3.
//  Copyright © 2020 com.alirio.lau.www. All rights reserved.
//

import Foundation

public struct ALOptionalWrapper {
  public typealias OptionalType = Optional<String>
  public let base: OptionalType
  init(_ base: OptionalType) {
    self.base = base
  }
}

extension Optional where Wrapped == String {
  var al: ALOptionalWrapper {
    get { return ALOptionalWrapper(self) }
    set { }
  }
}

public extension ALOptionalWrapper {

  var val: String {
    base ?? ""
  }

}
