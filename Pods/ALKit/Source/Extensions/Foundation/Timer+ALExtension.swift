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
//  Timer+ALExtension.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2019/12/3.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import Foundation

public extension ALWrapper where Base: Timer {

  @discardableResult
  static func after(_ interval: TimeInterval, _ block: @escaping () -> Void) -> Timer {
    let timer = Timer.al.new(after: interval, block)
    timer.al.start()
    return timer
  }

  @discardableResult
  static func every(_ interval: TimeInterval, _ block: @escaping () -> Void) -> Timer {
    let timer = Timer.al.new(every: interval, block)
    timer.al.start()
    return timer
  }

  @discardableResult
  static func every(_ interval: TimeInterval, _ block: @escaping (Timer) -> Void) -> Timer {
    let timer = Timer.al.new(every: interval, block)
    timer.al.start()
    return timer
  }

  static func new(after interval: TimeInterval, _ block: @escaping () -> Void) -> Timer {
    return CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + interval, 0, 0, 0) { _ in
      block()
    }
  }

  static func new(every interval: TimeInterval, _ block: @escaping () -> Void) -> Timer {
    return CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + interval, interval, 0, 0) { _ in
      block()
    }
  }

  static func new(every interval: TimeInterval, _ block: @escaping (Timer) -> Void) -> Timer {
    var timer: Timer!
    timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + interval, interval, 0, 0) { _ in
      block(timer)
    }
    return timer
  }
}

public extension ALWrapper where Base == Timer {

  func start(runLoop: RunLoop = .current, modes: RunLoop.Mode...) {
    let modes = modes.isEmpty ? [.default] : modes
    for mode in modes {
      runLoop.add(base, forMode: mode)
    }
  }

}
