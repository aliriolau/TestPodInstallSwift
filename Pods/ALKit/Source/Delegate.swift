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
//  Delegate.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2019/12/26.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import Foundation

public class Delegate<Input, Output> {
  init() {}

  private var block: ((Input) -> Output?)?

  public func delegate<T: AnyObject>(on target: T, execute: ((T, Input) -> Output)?) {
    block = { [weak target] input in
      guard let target = target else { return nil }
      return execute?(target, input)
    }
  }

  public func call(_ input: Input) -> Output? {
    block?(input)
  }
  
}

public extension Delegate where Input == Void {
  func call() -> Output? {
    call(())
  }
}
