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
//  ObjC+Invocation.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2019/12/26.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import Foundation

private let NSInvocation: AnyClass = NSClassFromString("NSInvocation")!

// Methods of `NSInvocation`.
@objc private protocol ObjCInvocation {
  @objc(invocationWithMethodSignature:)
  static func invocation(methodSignature: AnyObject) -> AnyObject

  @objc(methodSignature)
  var objcMethodSignature: AnyObject { get }

  @objc(target)
  var objcTarget: AnyObject { get }
  @objc(setTarget:)
  func setTarget(_ target: AnyObject)

  @objc(selector)
  var objcSelector: Selector { get }
  @objc(setSelector:)
  func setSelector(_ selector: Selector)

  @objc(getArgument:atIndex:)
  func getArgument(_ argumentLocation: UnsafeMutableRawPointer, atIndex idx: Int)
  @objc(setArgument:atIndex:)
  func setArgument(_ argumentLocation: UnsafeMutableRawPointer, atIndex idx: Int)

  @objc(invoke)
  func invoke()
  @objc(invokeWithTarget:)
  func invoke(target: AnyObject)
}

protocol SwiftInvocation {
  var target: AnyObject { get set }
  var selector: Selector { get set }

  func getArgument(_ location: UnsafeMutableRawPointer, atIndex index: Int)
  func setArgument(_ location: UnsafeMutableRawPointer, atIndex index: Int)

  func invoke()
  func invoke(for target: AnyObject)
}

public class Invocation: NSObject, SwiftInvocation {

  private var invocation: AnyObject = NSObject()
  public let methodSignature: MethodSignature

  private override init() {
    methodSignature = MethodSignature(objCTypes: ObjCMethodEncoding.class)
  }

  public init(methodSignature: MethodSignature) {
    self.methodSignature = methodSignature
    invocation = NSInvocation.invocation(methodSignature: methodSignature.objcMethodSignature)
  }

  public init(invocation: AnyObject/*NSInvocation*/) {
    self.invocation = invocation
    methodSignature = MethodSignature(signature: invocation.objcMethodSignature)
  }

  var target: AnyObject {
    get { invocation.objcTarget }
    set { invocation.setTarget(newValue) }
  }

  var selector: Selector {
    get { invocation.objcSelector }
    set { invocation.setSelector(newValue) }
  }

  func getArgument(_ location: UnsafeMutableRawPointer, atIndex index: Int) {
    invocation.getArgument(location, atIndex: index)
  }

  func setArgument(_ location: UnsafeMutableRawPointer, atIndex index: Int) {
    invocation.setArgument(location, atIndex: index)
  }

  func invoke() {
    invocation.invoke()
  }

  func invoke(for target: AnyObject) {
    invocation.invoke(target: target)
  }
}
