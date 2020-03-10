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
//  UITextView+ALExtension.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2019/12/2.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import UIKit

// TextFormatter
public extension ALWrapper where Base == UITextView {
  func setCursorLocation(_ location: Int) {
    if let cursorLocation = base.position(from: base.beginningOfDocument, offset: location) {
      DispatchQueue.main.async { [weak base] in
        guard let strongSelf = base else { return }
        strongSelf.selectedTextRange = strongSelf.textRange(from: cursorLocation, to: cursorLocation)
      }
    }
  }
}
