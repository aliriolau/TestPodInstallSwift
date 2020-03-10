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
//  NSObject+Association.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2019/12/26.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import Foundation

public struct AssociationKey<Value> {
  fileprivate let address: UnsafeRawPointer
  fileprivate let `default`: Value!

  /// Create an ObjC association key.
  ///
  /// - warning: The key must be uniqued.
  ///
  /// - parameters:
  ///   - default: The default value, or `nil` to trap on undefined value. It is
  ///              ignored if `Value` is an optional.
  init(default: Value? = nil) {
    self.address = UnsafeRawPointer(UnsafeMutablePointer<UInt8>.allocate(capacity: 1))
    self.default = `default`
  }

  /// Create an ObjC association key from a `StaticString`.
  ///
  /// - precondition: `key` has a pointer representation.
  ///
  /// - parameters:
  ///   - default: The default value, or `nil` to trap on undefined value. It is
  ///              ignored if `Value` is an optional.
  init(_ key: StaticString, default: Value? = nil) {
    assert(key.hasPointerRepresentation)
    self.address = UnsafeRawPointer(key.utf8Start)
    self.default = `default`
  }

  /// Create an ObjC association key from a `Selector`.
  ///
  /// - parameters:
  ///   - default: The default value, or `nil` to trap on undefined value. It is
  ///              ignored if `Value` is an optional.
  init(_ key: Selector, default: Value? = nil) {
    self.address = UnsafeRawPointer(key.utf8Start)
    self.default = `default`
  }
}

public struct Associations<Base: AnyObject> {
  fileprivate let base: Base
  public init(_ base: Base) {
    self.base = base
  }
}

public extension Associations {
  /// Retrieve the associated value for the specified key.
  ///
  /// - parameters:
  ///   - key: The key.
  ///
  /// - returns: The associated value, or the default value if no value has been
  ///            associated with the key.
  func value<Value>(forKey key: AssociationKey<Value>) -> Value {
    return (objc_getAssociatedObject(base, key.address) as? Value) ?? key.default
  }

  /// Retrieve the associated value for the specified key.
  ///
  /// - parameters:
  ///   - key: The key.
  ///
  /// - returns: The associated value, or `nil` if no value is associated with
  ///            the key.
  func value<Value>(forKey key: AssociationKey<Value?>) -> Value? {
    return objc_getAssociatedObject(base, key.address) as? Value
  }

  /// Set the associated value for the specified key.
  ///
  /// - parameters:
  ///   - value: The value to be associated.
  ///   - key: The key.
  func setValue<Value>(_ value: Value, forKey key: AssociationKey<Value>) {
    objc_setAssociatedObject(base, key.address, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
  }

  /// Set the associated value for the specified key.
  ///
  /// - parameters:
  ///   - value: The value to be associated.
  ///   - key: The key.
  func setValue<Value>(_ value: Value?, forKey key: AssociationKey<Value?>) {
    objc_setAssociatedObject(base, key.address, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
  }
}

extension NSObjectProtocol {
  @nonobjc public var associations: Associations<Self> {
    return Associations(self)
  }
}
