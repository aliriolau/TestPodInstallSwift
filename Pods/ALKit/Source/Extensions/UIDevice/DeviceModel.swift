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
//  DeviceModel.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2019/12/24.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import Foundation

public enum DeviceModel: CaseIterable {

  case iPhone4, iPhone4S
  case iPhone5, iPhone5C, iPhone5S
  case iPhone6, iPhone6Plus
  case iPhone6S, iPhone6SPlus
  case iPhoneSE
  case iPhone7, iPhone7Plus
  case iPhone8, iPhone8Plus
  case iPhoneX
  case iPhoneXS, iPhoneXSMax
  case iPhoneXR
  case iPhone11
  case iPhone11Pro, iPhone11ProMax

  case iPadFirstGen, iPadSecondGen, iPadThirdGen, iPadFourthGen, iPadFifthGen, iPadSixthGen, iPadSevenGen
  case iPadAir, iPadAir2, iPadAir3
  case iPadMini, iPadMini2, iPadMini3, iPadMini4, iPadMini5
  case iPadPro9_7Inch, iPadPro10_5Inch, iPadPro12_9Inch, iPadPro12_9Inch_SecondGen
  case iPadPro11Inch, iPadPro12_9Inch_ThirdGen

  case iPodTouchFirstGen, iPodTouchSecondGen, iPodTouchThirdGen,
  iPodTouchFourthGen, iPodTouchFifthGen, iPodTouchSixthGen, iPodTouchSeventhGen

  case unknown

  public static let iPhoneXModels: [DeviceModel] = [.iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhoneXR, .iPhone11, .iPhone11Pro, iPhone11ProMax, ]
  public static let iPhonePlusModels: [DeviceModel] = [.iPhone6Plus, .iPhone6SPlus, .iPhone7Plus, .iPhone8Plus, ]
}

// MARK: - init

extension DeviceModel {
  init(identifier: DeviceIdentifier) {
    switch identifier.type {
    case .iPhone:
      self = DeviceModel.iPhoneModel(with: identifier)
    case .iPad:
      self = DeviceModel.iPadModel(with: identifier)
    case .iPod:
      self = DeviceModel.iPodModel(with: identifier)
    default:
      self = .unknown
    }
  }

  private static func iPhoneModel(with identifier: DeviceIdentifier) -> DeviceModel {
    guard identifier.type == .iPhone,
      let major = identifier.version.major,
      let minor = identifier.version.minor
      else { return .unknown }

    switch (major, minor) {
    case (3, _):            return .iPhone4
    case (4, _):            return .iPhone4S
    case (5, 1), (5, 2):    return .iPhone5
    case (5, 3), (5, 4):    return .iPhone5C
    case (6, _):            return .iPhone5S
    case (7, 2):            return .iPhone6
    case (7, 1):            return .iPhone6Plus
    case (8, 1):            return .iPhone6S
    case (8, 2):            return .iPhone6SPlus
    case (8, 4):            return .iPhoneSE
    case (9, 1), (9, 3):    return .iPhone7
    case (9, 2), (9, 4):    return .iPhone7Plus
    case (10, 1), (10, 4):  return .iPhone8
    case (10, 2), (10, 5):  return .iPhone8Plus
    case (10, 3), (10, 6):  return .iPhoneX
    case (11, 2):           return .iPhoneXS
    case (11, 4), (11, 6):  return .iPhoneXSMax
    case (11, 8):           return .iPhoneXR
    case (12, 1):           return .iPhone11
    case (12, 3):           return .iPhone11Pro
    case (12, 5):           return .iPhone11ProMax
    default:                return .unknown
    }
  }

  private static func iPadModel(with identifier: DeviceIdentifier) -> DeviceModel {
    guard identifier.type == .iPad,
      let major = identifier.version.major,
      let minor = identifier.version.minor
      else { return .unknown }

    switch (major, minor) {
    case (1, _):                          return .iPadFirstGen
    case (2, 1), (2, 2), (2, 3), (2, 4):  return .iPadSecondGen
    case (3, 1), (3, 2), (3, 3):          return .iPadThirdGen
    case (3, 4), (3, 5), (3, 6):          return .iPadFourthGen
    case (6, 11), (6, 12):                return .iPadFifthGen
    case (7, 5), (7, 6):                  return .iPadSixthGen
    case (4, 1), (4, 2), (4, 3):          return .iPadAir
    case (5, 3), (5, 4):                  return .iPadAir2
    case (11, 3), (11, 4):                return .iPadAir3
    case (2, 5), (2, 6), (2, 7):          return .iPadMini
    case (4, 4), (4, 5), (4, 6):          return .iPadMini2
    case (4, 7), (4, 8), (4, 9):          return .iPadMini3
    case (5, 1), (5, 2):                  return .iPadMini4
    case (11, 1), (11, 2):                return .iPadMini5
    case (6, 3), (6, 4):                  return .iPadPro9_7Inch
    case (7, 3), (7, 4):                  return .iPadPro10_5Inch
    case (8, 1), (8, 2), (8, 3), (8, 4):  return .iPadPro11Inch
    case (6, 7), (6, 8):                  return .iPadPro12_9Inch
    case (7, 1), (7, 2):                  return .iPadPro12_9Inch_SecondGen
    case (8, 5), (8, 6), (8, 7), (8, 8):  return .iPadPro12_9Inch_ThirdGen
    case (7, 11), (7, 12):                return .iPadSevenGen
    default:                              return .unknown
    }
  }

  private static func iPodModel(with identifier: DeviceIdentifier) -> DeviceModel {
    guard identifier.type == .iPod,
      let major = identifier.version.major,
      let minor = identifier.version.minor
      else { return .unknown }

    switch (major, minor) {
    case (1, 1):          return .iPodTouchFirstGen
    case (2, 1):          return .iPodTouchSecondGen
    case (3, 1):          return .iPodTouchThirdGen
    case (4, 1):          return .iPodTouchFourthGen
    case (5, 1):          return .iPodTouchFifthGen
    case (7, 1):          return .iPodTouchSixthGen
    case (9, 1):          return .iPodTouchSeventhGen
    default:              return .unknown
    }
  }
}
