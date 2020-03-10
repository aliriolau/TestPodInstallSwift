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
//  UIImageView+ALExtension.swift
//  ALAppCodesSwift
//
//  Created by Alirio-Lau on 2019/12/1.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import UIKit

public extension ALWrapper where Base: UIImageView {

  func blur(withStyle style: UIBlurEffect.Style = .light) {
    let blurEffect = UIBlurEffect(style: style)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = base.bounds
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
    base.addSubview(blurEffectView)
    base.clipsToBounds = true
  }

  func blurred(withStyle style: UIBlurEffect.Style = .light) -> UIImageView {
    let imgView = base
    imgView.al.blur(withStyle: style)
    return imgView
  }

}
