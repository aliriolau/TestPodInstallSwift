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
//  UIStackView+ALExtension.swift
//  ALAppCodesSwift
//
//  Created by Alirio-Lau on 2019/12/1.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
public extension UIStackView {

  convenience init(
    subviews: [UIView],
    axis: NSLayoutConstraint.Axis = .horizontal,
    spacing: CGFloat = 0.0,
    alignment: UIStackView.Alignment = .fill,
    distribution: UIStackView.Distribution = .fill
  ) {
    self.init(arrangedSubviews: subviews)
    self.axis = axis
    self.spacing = spacing
    self.alignment = alignment
    self.distribution = distribution
  }

}

@available(iOS 9.0, *)
public extension ALWrapper where Base == UIStackView {

  func addArrangedSubviews(_ views: [UIView]) {
    for view in views {
      base.addArrangedSubview(view)
    }
  }

  /// Removes all views in stack’s array of arranged subviews.
  func removeArrangedSubviews() {
    for view in base.arrangedSubviews {
      base.removeArrangedSubview(view)
    }
  }

}
