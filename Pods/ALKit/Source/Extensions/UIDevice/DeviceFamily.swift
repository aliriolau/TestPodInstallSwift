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
//  DeviceFamily.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2019/12/24.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import Foundation

public enum DeviceFamily: String {
  case iPhone
  case iPad
  case iPod
  case unknown

  public init(rawValue: String) {
    switch rawValue {
    case "iPhone":
      self = .iPhone
    case "iPad":
      self = .iPad
    case "iPod":
      self = .iPod
    default:
      self = .unknown
    }
  }
}

// MARK: Simulator Detection

extension DeviceFamily {
  public var isSimulator: Bool {
    #if arch(i386) || arch(x86_64)
    return true
    #else
    return false
    #endif
  }
}
