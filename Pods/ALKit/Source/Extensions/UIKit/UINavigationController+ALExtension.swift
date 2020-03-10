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
//  UINavigationController+ALExtension.swift
//  ALAppCodesSwift
//
//  Created by Alirio-Lau on 2019/12/1.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import UIKit

public extension ALWrapper where Base == UINavigationController {

  // https://github.com/cotkjaer/UserInterface/blob/master/UserInterface/UIViewController.swift
  func popViewController(animated: Bool = true, _ completion: (() -> Void)? = nil) {
    CATransaction.begin()
    CATransaction.setCompletionBlock(completion)
    base.popViewController(animated: animated)
    CATransaction.commit()
  }

  // https://github.com/cotkjaer/UserInterface/blob/master/UserInterface/UIViewController.swift
  func pushViewController(_ viewController: UIViewController, completion: (() -> Void)? = nil) {
    CATransaction.begin()
    CATransaction.setCompletionBlock(completion)
    base.pushViewController(viewController, animated: true)
    CATransaction.commit()
  }

  /// Make navigation controller's navigation bar transparent.
  ///
  /// - Parameter tint: tint color (default is .white).
  func makeTransparent(withTint tint: UIColor = .white) {
    base.navigationBar.setBackgroundImage(UIImage(), for: .default)
    base.navigationBar.shadowImage = UIImage()
    base.navigationBar.isTranslucent = true
    base.navigationBar.tintColor = tint
    base.navigationBar.titleTextAttributes = [.foregroundColor: tint]
  }

}
