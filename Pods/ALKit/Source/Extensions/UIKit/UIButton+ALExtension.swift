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
//  UIButton+ALExtension.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2019/12/19.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import UIKit
import CoreGraphics

public extension ALWrapper where Base == UIButton {

  func alignHorizontal(spacing: CGFloat, imageFirst: Bool = true) {
    let offset = spacing * 0.5

    base.imageEdgeInsets = UIEdgeInsets(top: 0, left: -offset, bottom: 0, right: offset)
    base.titleEdgeInsets = UIEdgeInsets(top: 0, left: offset, bottom: 0, right: -offset)

    if imageFirst == false {
      base.transform = CGAffineTransform(scaleX: -1, y: 1)
      base.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
      base.titleLabel?.transform = CGAffineTransform(scaleX: -1, y: 1)
    }

    base.contentEdgeInsets = UIEdgeInsets(top: 0, left: offset, bottom: 0, right: offset)
  }

  func alignHorizontalInsets(spacing: CGFloat, imageFirst: Bool = true) {
    let offset = spacing * 0.5

    if (imageFirst) {
      base.imageEdgeInsets = UIEdgeInsets(top: 0, left: -offset, bottom: 0, right: offset)
      base.titleEdgeInsets = UIEdgeInsets(top: 0, left: offset, bottom: 0, right: -offset)
    } else {
      guard let imageSize = base.imageView?.image?.size,
        let labelString = base.titleLabel?.text,
        let font = base.titleLabel?.font else {
          return
      }

      let titleSize = (labelString as NSString).size(withAttributes: [NSAttributedString.Key.font : font])

      base.imageEdgeInsets = UIEdgeInsets(top: 0, left: titleSize.width + offset,
                                          bottom: 0, right: -titleSize.width - offset)

      base.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width - offset,
                                          bottom: 0, right: imageSize.width + offset)
    }

    // increase content width to avoid clipping
    base.contentEdgeInsets = UIEdgeInsets(top: 0, left: offset, bottom: 0, right: offset)
  }

  func alignVertical(spacing: CGFloat, imageTop: Bool = true) {
    guard let imageSize = base.imageView?.image?.size,
      let labelString = base.titleLabel?.text,
      let font = base.titleLabel?.font else {
        return
    }

    let titleSize = (labelString as NSString).size(withAttributes: [NSAttributedString.Key.font : font])

    let imageVOffset = (titleSize.height + spacing) * 0.5
    let titleVOffset = (imageSize.height + spacing) * 0.5
    let imageHOffset = titleSize.width * 0.5
    let titleHOffset = imageSize.width * 0.5

    let sign = CGFloat(imageTop ? 1 : -1)

    base.imageEdgeInsets = UIEdgeInsets(
      top: -imageVOffset * sign,
      left: imageHOffset,
      bottom: imageVOffset * sign,
      right: -imageHOffset)

    base.titleEdgeInsets = UIEdgeInsets(
      top: titleVOffset * sign,
      left: -titleHOffset,
      bottom: -titleVOffset * sign,
      right: titleHOffset)

    let offset = (min(imageSize.height, titleSize.height) + spacing) * 0.5

    base.contentEdgeInsets = UIEdgeInsets(top: offset, left: 0, bottom: offset, right: 0)
  }

}
