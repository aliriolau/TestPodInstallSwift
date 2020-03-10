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
//  UIFont+ALTheme.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2019/11/30.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import UIKit

extension UIFont {
  public struct Theme {
    private init() {}

    public static func chineseFont(
      ofSize size: CGFloat,
      weight: ALWrapper<UIFont>.ChineseFontWeight = .regular
    ) -> UIFont {
      let name = "PingFangSC" + weight.rawValue
      return UIFont(name: name, size: size)!
    }

    public static func asciiFont(
      ofSize size: CGFloat,
      weight: ALWrapper<UIFont>.ASCIIFontWeight = .regular
    ) -> UIFont {
      let name = "HelveticaNeue" + weight.rawValue
      return UIFont(name: name, size: size)!
    }
  }
}

public extension ALWrapper where Base: UIFont {

  enum ChineseFontWeight: String {
    case ligth = "-Light"
    case regular = "-Regular"
    case medium = "-Medium"
    case semibold = "-Semibold"
  }

  enum ASCIIFontWeight: String {
    case ligth = "-Light"
    case regular = ""
    case medium = "-Medium"
    case bold = "-Bold"
  }

  // MARK: - Chinese Font
  static func lightChineseFont(ofSize size: CGFloat) -> UIFont {
    return UIFont(name: "PingFangSC-Light", size: size)!
  }

  static func regularChineseFont(ofSize size: CGFloat) -> UIFont {
    return UIFont(name: "PingFangSC-Regular", size: size)!
  }

  static func mediumChineseFont(ofSize size: CGFloat) -> UIFont {
     return UIFont(name: "PingFangSC-Medium", size: size)!
  }

  static func semiboldChineseFont(ofSize size: CGFloat) -> UIFont {
     return UIFont(name: "PingFangSC-Semibold", size: size)!
  }

  // MARK: - ASCII Font
  static func lightASCIIFont(ofSize size: CGFloat) -> UIFont {
     return UIFont(name: "HelveticaNeue-Light", size: size)!
  }

  static func regularASCIIFont(ofSize size: CGFloat) -> UIFont {
     return UIFont(name: "HelveticaNeue", size: size)!
  }

  static func mediumASCIIFont(ofSize size: CGFloat) -> UIFont {
     return UIFont(name: "HelveticaNeue-Medium", size: size)!
  }

  static func boldASCIIFont(ofSize size: CGFloat) -> UIFont {
     return UIFont(name: "HelveticaNeue-Bold", size: size)!
  }

}
