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
//  UserDefaults+ALExtension.swift
//  ALAppCodesSwift
//
//  Created by Alirio-Lau on 2019/12/1.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import Foundation

public extension ALWrapper where Base == UserDefaults {

  func float(forKey key: String) -> Float? {
    return base.object(forKey: key) as? Float
  }

  func date(forKey key: String) -> Date? {
    return base.object(forKey: key) as? Date
  }

  func object<T: Codable>(_ type: T.Type, with key: String, usingDecoder decoder: JSONDecoder = JSONDecoder()) -> T? {
    guard let data = base.value(forKey: key) as? Data else { return nil }
    return try? decoder.decode(type.self, from: data)
  }

  /// Allows storing of Codable objects to UserDefaults.
  ///
  /// - Parameters:
  ///   - object: Codable object to store.
  ///   - key: Identifier of the object.
  ///   - encoder: Custom JSONEncoder instance. Defaults to `JSONEncoder()`.
  func set<T: Codable>(object: T, forKey key: String, usingEncoder encoder: JSONEncoder = JSONEncoder()) {
    let data = try? encoder.encode(object)
    base.set(data, forKey: key)
  }

}

public extension UserDefaults {

  /// get object from UserDefaults by using subscript
  ///
  /// - Parameter key: key in the current user's defaults database.
  subscript(key: String) -> Any? {
    get { return object(forKey: key) }
    set { set(newValue, forKey: key) }
  }

}
