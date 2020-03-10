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
//  UINavigationBar+ALExtension.swift
//  ALAppCodesSwift
//
//  Created by Alirio-Lau on 2019/12/1.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import UIKit

public extension ALWrapper where Base == UINavigationBar {

  func setTitleFont(_ font: UIFont, color: UIColor = .black) {
    var attrs = [NSAttributedString.Key: Any]()
    attrs[.font] = font
    attrs[.foregroundColor] = color
    base.titleTextAttributes = attrs
  }
  
  func makeTransparent(withTint tint: UIColor = .white) {
    base.isTranslucent = true
    base.backgroundColor = .clear
    base.barTintColor = .clear
    base.setBackgroundImage(UIImage(), for: .default)
    base.tintColor = tint
    base.titleTextAttributes = [.foregroundColor: tint]
    base.shadowImage = UIImage()
  }

  func setColors(background: UIColor, text: UIColor) {
    base.isTranslucent = false
    base.backgroundColor = background
    base.barTintColor = background
    base.setBackgroundImage(UIImage(), for: .default)
    base.tintColor = text
    base.titleTextAttributes = [.foregroundColor: text]
  }

}
