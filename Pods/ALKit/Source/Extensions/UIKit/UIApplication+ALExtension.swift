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
//  UIApplication+ALExtension.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2019/12/25.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import UIKit

public extension ALWrapper where Base: UIApplication {

  enum Environment {
    /// Application is running in debug mode.
    case debug
    /// Application is installed from Test Flight.
    case testFlight
    /// Application is installed from the App Store.
    case appStore
  }

  /// Current inferred app environment.
  var inferredEnvironment: Environment {
    #if DEBUG
    return .debug

    #elseif targetEnvironment(simulator)
    return .debug

    #else
    if Bundle.main.path(forResource: "embedded", ofType: "mobileprovision") != nil {
      return .testFlight
    }

    guard let appStoreReceiptUrl = Bundle.main.appStoreReceiptURL else {
      return .debug
    }

    if appStoreReceiptUrl.lastPathComponent.lowercased() == "sandboxreceipt" {
      return .testFlight
    }

    if appStoreReceiptUrl.path.lowercased().contains("simulator") {
      return .debug
    }

    return .appStore
    #endif
  }

  func runInBackground(
    _ closure: @escaping () -> Void,
    expirationHandler: (() -> Void)? = nil
  ) {
    DispatchQueue.main.async {
      let taskID: UIBackgroundTaskIdentifier
      if let expirationHandler = expirationHandler {
        taskID = self.base.beginBackgroundTask(expirationHandler: expirationHandler)
      } else {
        taskID = self.base.beginBackgroundTask(expirationHandler: { })
      }
      closure()
      self.base.endBackgroundTask(taskID)
    }
  }

}
