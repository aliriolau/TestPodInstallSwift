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
//  Error+ALExtension.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2019/12/28.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import Foundation

public struct ALErrorWrapper {
  public let base: Error
  public init(_ base: Error) {
    self.base = base
  }
}

extension Error {
  var al: ALErrorWrapper {
    get { return ALErrorWrapper(self) }
    set { }
  }
}

public extension ALErrorWrapper {
  var code: Int {
    (base as NSError).code
  }

  var domain: String {
    (base as NSError).domain
  }

  var userInfo: [String: Any] {
    (base as NSError).userInfo
  }
}
