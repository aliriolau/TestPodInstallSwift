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
//  UIDevice+ALExtension.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2019/12/4.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import UIKit

public final class ALWrapperDeviceModuleNameClass {}

// MARK: - Variables

public extension ALWrapper where Base: UIDevice {

  static var appVersion: String {
    if let shortVersion = Bundle.main.infoDictionary?[path: ["CFBundleShortVersionString"]] as? String {
      return shortVersion
    }

    return ""
  }

  static var appName: String {
    if let name = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
      return name
    } else if let name = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
      return name
    }

    return ""
  }

  static var moduleName: String {
    let selfClass = NSStringFromClass(ALWrapperDeviceModuleNameClass.self)
    guard let moduleName = selfClass.components(separatedBy: ".").first else {
      return ""
    }

    return moduleName
  }

  static var osVersion: String {
    UIDevice.current.systemVersion
  }

  /// Returns OS version without subversions.
  ///
  /// Example: 9.
  static var osMajorVersion: Int {
    let subVersion = UIDevice.current.systemVersion.al.substring(to: ".")
    guard let intSubVersion = Int(subVersion) else { return 0 }
    return intSubVersion
  }

  /// Device family i.e iPhone, iPod, iPad
  static var deviceFamily: DeviceFamily {
    return DeviceSystem.shared.identifier.type
  }

  /// Specific model i.e iphone7 or iPhone7s
  static var deviceModel: DeviceModel {
    return DeviceModel(identifier: DeviceSystem.shared.identifier)
  }

  /// Specific name for device i.e "iPhone 7 Plus"
  static var deviceName: String {
    return DeviceSystem.shared.identifier.description
  }

  /// Retruns if current device is running in low power mode.
  @available(iOS 9.0, *)
  static var isLowPowerModeEnabled: Bool {
    ProcessInfo.processInfo.isLowPowerModeEnabled
  }

  static var iPhoneX: Bool {
    DeviceModel.iPhoneXModels.contains(deviceModel)
  }

  static var iPhonePlus: Bool {
    DeviceModel.iPhonePlusModels.contains(deviceModel)
  }
}

// MARK: - System Detail Info

public extension ALWrapper where Base: UIDevice {

  /// Returns current device CPU frequency.
  static var cpuFrequency: Int {
    getSysInfo(HW_CPU_FREQ)
  }

  /// Returns current device BUS frequency.
  static var busFrequency: Int {
    getSysInfo(HW_TB_FREQ)
  }

  /// Returns device RAM size.
  static var ramSize: Int {
    getSysInfo(HW_MEMSIZE)
  }

  /// Returns device CPUs number.
  static var cpusNumber: Int {
    getSysInfo(HW_NCPU)
  }

  /// Returns device total memory.
  static var totalMemory: Int {
    getSysInfo(HW_PHYSMEM)
  }

  /// Returns current device non-kernel memory.
  static var userMemory: Int {
    getSysInfo(HW_USERMEM)
  }

  /// Used to the system info.
  ///
  /// - Parameter typeSpecifier: Type of system info.
  /// - Returns: Return sysyem info.
  fileprivate static func getSysInfo(_ typeSpecifier: Int32) -> Int {
    var name: [Int32] = [CTL_HW, typeSpecifier]
    var nameCopy = name
    var size: Int = 2
    sysctl(&nameCopy, 2, nil, &size, &name, 0)
    var results: Int = 0
    sysctl(&nameCopy, 2, &results, &size, &name, 0)

    return results
  }

  static func isJailBroken() -> Bool {
    let canReadBinBash = FileManager.default.fileExists(atPath: "/bin/bash")
    if let cydiaURL = URL(string: "cydia://"), let canOpenCydia = (UIApplication.value(forKey: "sharedApplication") as? UIApplication)?.canOpenURL(cydiaURL) {
      return canOpenCydia || canReadBinBash
    } else {
      return canReadBinBash
    }
  }

  static func totalDiskSpace() -> NSNumber {
    do {
      let attributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
      return attributes[.systemSize] as? NSNumber ?? NSNumber(value: 0.0)
    } catch {
      return NSNumber(value: 0.0)
    }
  }

  static func freeDiskSpace() -> NSNumber {
    do {
      let attributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
      return attributes[.systemFreeSize] as? NSNumber ?? NSNumber(value: 0.0)
    } catch {
      return NSNumber(value: 0.0)
    }
  }

}
