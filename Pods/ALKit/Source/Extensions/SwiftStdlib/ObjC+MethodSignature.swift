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
//  ObjC+MethodSignature.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2019/12/26.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import Foundation

private let NSMethodSignature: AnyClass = NSClassFromString("NSMethodSignature")!

// Methods of `NSMethodSignature`.
@objc private protocol ObjCMethodSignature {
  @objc(signatureWithObjCTypes:)
  static func signature(objCTypes: UnsafePointer<CChar>) -> AnyObject

  @objc(numberOfArguments)
  var objcNumberOfArguments: UInt { get }

  @objc(getArgumentTypeAtIndex:)
  func getArgumentType(at index: UInt) -> UnsafePointer<CChar>
}

protocol SwiftMethodSignature {
  var numberOfArguments: UInt { get }
  var objcMethodSignature: AnyObject { get }
  func getArgumentType(at index: UInt) -> UnsafePointer<CChar>
}

public class MethodSignature: NSObject, SwiftMethodSignature {

  var numberOfArguments: UInt { signature.objcNumberOfArguments }
  var objcMethodSignature: AnyObject { signature }

  private var signature: AnyObject = NSObject()
  private override init() { }

  public init(objCTypes: UnsafePointer<CChar>) {
    signature = NSMethodSignature.signature(objCTypes: objCTypes)
  }

  public init(signature: AnyObject/*NSMethodSignature*/) {
    self.signature = signature
  }

  func getArgumentType(at index: UInt) -> UnsafePointer<CChar> {
    return signature.getArgumentType(at: index)
  }
}
