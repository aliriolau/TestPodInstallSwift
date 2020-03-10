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
//  ViewController.swift
//  TestPodInstallSwift
//
//  Created by Alirio Lau on 2020/3/9.
//  Copyright © 2020 Alirio.Lau. All rights reserved.
//

import UIKit
import ALKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    let lock = SpinLock()
    
    lock.lock()
    
    defer {
      lock.unlock()
    }
    
    printLog("test")
  }


}

