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
//  UIViewController+ALExtension.swift
//  ALAppCodesSwift
//
//  Created by Alirio-Lau on 2019/12/1.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import UIKit

@inline(__always)
public func topViewController(
  _ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
) -> UIViewController? {
  if let nav = base as? UINavigationController {
    return topViewController(nav.visibleViewController)
  }

  if let tab = base as? UITabBarController {
    if let selected = tab.selectedViewController {
      return topViewController(selected)
    }
  }

  if let presented = base?.presentedViewController {
    return topViewController(presented)
  }

  return base
}

public extension ALWrapper where Base: UIViewController {

  var isVisible: Bool {
    // http://stackoverflow.com/questions/2777438/how-to-tell-if-uiviewcontrollers-view-is-visible
    return base.isViewLoaded && base.view.window != nil
  }

  func addNotification(ofName name: Notification.Name, selector: Selector) {
    NotificationCenter.default.addObserver(base, selector: selector, name: name, object: nil)
  }

  func removeNotification(ofName name: Notification.Name) {
    NotificationCenter.default.removeObserver(base, name: name, object: nil)
  }

  func removeNotifications() {
    NotificationCenter.default.removeObserver(base)
  }

  @discardableResult
  func showAlert(
    title: String?,
    message: String?,
    buttonTitles: [String]? = nil,
    highlightedButtonIndex: Int? = nil,
    completion: ((Int) -> Void)? = nil
  ) -> UIAlertController {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    var allButtons = buttonTitles ?? [String]()
    if allButtons.count == 0 {
      allButtons.append("OK")
    }

    for index in 0..<allButtons.count {
      let buttonTitle = allButtons[index]
      let action = UIAlertAction(title: buttonTitle, style: .default, handler: { (_) in
        completion?(index)
      })
      alertController.addAction(action)
      // Check which button to highlight
      if let highlightedButtonIndex = highlightedButtonIndex, index == highlightedButtonIndex {
        if #available(iOS 9.0, *) {
          alertController.preferredAction = action
        }
      }
    }
    base.present(alertController, animated: true, completion: nil)
    return alertController
  }

  func addChildViewController(_ child: UIViewController, toContainerView containerView: UIView) {
    base.addChild(child)
    containerView.addSubview(child.view)
    child.didMove(toParent: base)
  }

  /// Helper method to remove a UIViewController from its parent.
  func removeViewAndControllerFromParentViewController() {
    guard base.parent != nil else { return }
    base.willMove(toParent: nil)
    base.removeFromParent()
    base.view.removeFromSuperview()
  }

  func presentPopover(
    _ popoverContent: UIViewController,
    sourcePoint: CGPoint,
    size: CGSize? = nil,
    delegate: UIPopoverPresentationControllerDelegate? = nil,
    animated: Bool = true,
    completion: (() -> Void)? = nil
  ) {
    popoverContent.modalPresentationStyle = .popover

    if let size = size {
      popoverContent.preferredContentSize = size
    }

    if let popoverPresentationVC = popoverContent.popoverPresentationController {
      popoverPresentationVC.sourceView = base.view
      popoverPresentationVC.sourceRect = CGRect(origin: sourcePoint, size: .zero)
      popoverPresentationVC.delegate = delegate
    }

    base.present(popoverContent, animated: animated, completion: completion)
  }

}
