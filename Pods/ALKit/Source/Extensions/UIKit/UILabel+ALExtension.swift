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
//  UILabel+ALExtension.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2020/1/18.
//  Copyright © 2020 com.alirio.lau.www. All rights reserved.
//

import UIKit

extension UILabel {

  public convenience init(
    font: UIFont,
    color: UIColor = UIColor.Theme.black,
    alignment: NSTextAlignment = .left
  ) {
      self.init()
      self.font = font
      self.textColor = color
      self.textAlignment = alignment
  }

}
