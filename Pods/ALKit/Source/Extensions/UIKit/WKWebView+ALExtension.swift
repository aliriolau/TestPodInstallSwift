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
//  WKWebView+ALExtension.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2019/12/21.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import Foundation
import WebKit

public extension ALWrapper where Base == WKWebView {

  func load(_ website: String) {
    guard let url = URL(string: website) else { return }
    base.load(URLRequest(url: url))
  }

  func load(_ url: URL) {
    base.load(URLRequest(url: url))
  }
  
}
