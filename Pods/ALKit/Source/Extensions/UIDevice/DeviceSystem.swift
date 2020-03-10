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
//  DeviceSystem.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2019/12/24.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//
//  UIDeviceComplete

import Foundation

public struct DeviceSystem {
  public static let shared = DeviceSystem()
  public let identifier: DeviceIdentifier

  private init() {
    var machineName: [Int32] = [CTL_HW, HW_MACHINE]
    var nameCopy = machineName
    var size: Int = 2
    sysctl(&nameCopy, 2, nil, &size, &machineName, 0)
    var hwMachine = [CChar](repeating: 0, count: Int(size))
    sysctl(&nameCopy, 2, &hwMachine, &size, &machineName, 0)
    var hardware = String(cString: hwMachine)

    // Simulator 
    if hardware == "x86_64" || hardware == "i386" {
      let env = ProcessInfo.processInfo.environment
      hardware = env["SIMULATOR_MODEL_IDENTIFIER"] ?? ""
    }

    identifier = DeviceIdentifier(hardware)
  }
}
