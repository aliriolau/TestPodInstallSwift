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
//  Constant+ALTheme.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2019/11/30.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import UIKit

let kScreenW = UIScreen.main.bounds.width
let kScreenH = UIScreen.main.bounds.height

let kScreenW_2 = kScreenW * 0.5
let kScreenH_2 = kScreenH * 0.5

//let iPhoneX = UIScreen.main.bounds.size.height == 812.0 || UIScreen.main.bounds.size.height == 896.0
let iPhoneX = UIDevice.al.iPhoneX

let iPhoneXNavBarMargin = CGFloat(iPhoneX ? 24.0 : 0.0)//X与其他屏幕的导航栏高度差
let iPhoneXTabBarMargin = CGFloat(iPhoneX ? 34.0 : 0.0)//X与其他屏幕的底部tabbar高度差
let kStatusBarHeight = UIApplication.shared.statusBarFrame.size.height//状态栏高度
let kNavBarHeight = CGFloat(44.0)
let kTitleHeight = kNavBarHeight + kStatusBarHeight
let kTabBarHeight = CGFloat(iPhoneX ? 83.0 : 49.0)//tabbar高度

let kWRatio = kScreenW / 375.0
let kHRatio = kScreenH / 667.0

let kLineH = 1.0 * kWRatio

public func printLog<T>(
  _ message: T,
  file: String = #file,
  method: String = #function,
  line: Int = #line
) {
  #if DEBUG
  var debugInfo: String {
    var info = ""
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy HH:mm:ss:SSS"
    let timestamp = formatter.string(from: Date())
    let queue = Thread.isMainThread ? "Main" : "Background"
    info = "\(timestamp) \(queue)"

    return info
  }

  print("\(debugInfo) \((file as NSString).lastPathComponent)[\(line)], \(method):\n \(message)")
  #endif
}
