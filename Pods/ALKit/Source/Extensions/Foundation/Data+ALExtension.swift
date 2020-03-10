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
//  Data+ALExtension.swift
//  ALAppCodesSwift
//
//  Created by Alirio-Lau on 2019/12/1.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import Foundation

public struct ALDataWrapper {
  public let base: Data
  init(_ base: Data) {
    self.base = base
  }
}

public extension Data {
  var al: ALDataWrapper {
    get { return ALDataWrapper(self) }
    set { }
  }
}

public extension ALDataWrapper {

  var bytes: [UInt8] {
    // http://stackoverflow.com/questions/38097710/swift-3-changes-for-getbytes-method
    return [UInt8](base)
  }

  var hexString: String {
    let hexString = base.map { String(format: "%02.2hhx", $0) }.joined()
    return hexString
  }

  func utf8() -> String? {
    String(data: base, encoding: .utf8)
  }

  func ascii() -> String? {
    String(data: base, encoding: .ascii)
  }

  func string(encoding: String.Encoding) -> String? {
    return String(data: base, encoding: encoding)
  }

  func jsonObject(options: JSONSerialization.ReadingOptions = []) throws -> Any {
    return try JSONSerialization.jsonObject(with: base, options: options)
  }

}
