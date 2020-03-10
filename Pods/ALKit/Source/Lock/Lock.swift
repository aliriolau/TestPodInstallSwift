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
//  Lock.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2019/12/9.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import Foundation

public protocol Lockable {
  func lock()
  func unlock()
}

@available(iOS 10.0, *)
class UnfairLock: Lockable {
  private var unfairLock = os_unfair_lock_s()

  func lock() {
    os_unfair_lock_lock(&unfairLock)
  }

  func unlock() {
    os_unfair_lock_unlock(&unfairLock)
  }
}

struct MutexLock: Lockable {
  private let mutexLock = NSLock()

  func lock() {
    mutexLock.lock()
  }

  func unlock() {
    mutexLock.unlock()
  }
}

public struct SpinLock: Lockable {
  private let locker: Lockable

  public init() {
    if #available(iOS 10.0, *) {
      locker = UnfairLock()
    } else {
      locker = MutexLock()
    }
  }

  public func lock() {
    locker.lock()
  }

  public func unlock() {
    locker.unlock()
  }
}

public extension SpinLock {
  
  @inlinable
  func withLock<T>(_ body: () throws -> T) rethrows -> T {
    self.lock(); defer { self.unlock() }
    return try body()
  }

  @inlinable
  func withLockVoid(_ body: () throws -> Void) rethrows {
    try withLock(body)
  }
  
}
