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
//  ALKit+ALExtension.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2019/11/30.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import UIKit

//extension NSObject: ALCompatible {}

public extension NSObjectProtocol {
  static var al: ALWrapper<Self>.Type {
    get { return ALWrapper<Self>.self }
    set { }
  }
  
  var al: ALWrapper<Self> {
    get { return ALWrapper(self) }
    set { }
  }
}

@inlinable
public func synchronized<Result>(
  _ token: AnyObject,
  execute: () throws -> Result
) rethrows -> Result {
  objc_sync_enter(token)
  defer { objc_sync_exit(token) }
  return try execute()
}

@inlinable
public func block(_ work: () -> Void) {
  work()
}

@inlinable @discardableResult
public func callTelephone(_ phone: String) -> Bool {
  var charSet = CharacterSet()
  charSet.formUnion(.whitespaces)
  charSet.formUnion(.punctuationCharacters)
  charSet.formUnion(.symbols)

  let numberStr = phone.components(separatedBy: charSet).joined()

  printLog("numberStr = \(numberStr)")

  let urlStr = "tel://" + numberStr

  if let url = URL(string: urlStr) {
    UIApplication.shared.open(url)
    return true
  }

  return false
}
