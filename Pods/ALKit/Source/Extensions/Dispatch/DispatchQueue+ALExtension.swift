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
//  DispatchQueue+ALExtension.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2019/12/2.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import Foundation

fileprivate extension DispatchQueue {
  static var mainToken: DispatchSpecificKey<Void> = {
    let key = DispatchSpecificKey<Void>()
    DispatchQueue.main.setSpecific(key: key, value: ())
    return key
  }()
}

public extension ALWrapper where Base: DispatchQueue {
  static var isMain: Bool {
    return DispatchQueue.getSpecific(key: DispatchQueue.mainToken) != nil
  }
  
  static func after(_ delay: TimeInterval, work: @escaping () -> Void) {
    Base.main.asyncAfter(deadline: .now() + delay, execute: work)
  }
}
