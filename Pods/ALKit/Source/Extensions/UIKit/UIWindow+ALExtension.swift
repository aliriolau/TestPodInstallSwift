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
//  UIWindow+ALExtension.swift
//  ALAppCodesSwift
//
//  Created by Alirio-Lau on 2019/12/1.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import UIKit

public extension ALWrapper where Base == UIWindow {

  func switchRootViewController(
    to viewController: UIViewController,
    animated: Bool = true,
    duration: TimeInterval = 0.5,
    options: UIView.AnimationOptions = .transitionFlipFromRight,
    _ completion: (() -> Void)? = nil
  ) {
    guard animated else {
      base.rootViewController = viewController
      completion?()
      return
    }

    UIView.transition(with: base, duration: duration, options: options, animations: {
      let oldState = UIView.areAnimationsEnabled
      UIView.setAnimationsEnabled(false)
      self.base.rootViewController = viewController
      UIView.setAnimationsEnabled(oldState)
    }, completion: { _ in
      completion?()
    })
  }

}
