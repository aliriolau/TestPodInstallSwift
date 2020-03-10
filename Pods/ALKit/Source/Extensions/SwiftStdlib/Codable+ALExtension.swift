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
//  Codable+ALExtension.swift
//  ALAppCodesSwift
//
//  Created by Alirio-Lau on 2019/12/8.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import Foundation

public struct ALDecodableWrapper<Base: Decodable> {
  public let base: Base
  public init(_ base: Base) {
    self.base = base
  }
}

public struct ALEncodableWrapper<Base: Encodable> {
  public let base: Base
  public init(_ base: Base) {
    self.base = base
  }
}

public extension Decodable {
  static var al: ALDecodableWrapper<Self>.Type {
    get { return ALDecodableWrapper<Self>.self }
    set { }
  }
}

public extension Encodable {
  var al: ALEncodableWrapper<Self> {
    get { return ALEncodableWrapper<Self>(self) }
    set { }
  }
}

public extension ALDecodableWrapper {

  static func decode(from JSONString: String, designatedPath: String? = nil) -> Base? {
    guard let data = JSONString.data(using: .utf8), let jsonData = getInnerObject(inside: data, by: designatedPath) else {
      return nil
    }
    return try? JSONDecoder().decode(Base.self, from: jsonData)
  }

  static func decode(from JSON: Any?, designatedPath: String? = nil) -> Base? {
    guard let JSON = JSON, JSONSerialization.isValidJSONObject(JSON), let data = try? JSONSerialization.data(withJSONObject: JSON, options: []), let jsonData = getInnerObject(inside: data, by: designatedPath) else {
      return nil
    }
    return try? JSONDecoder().decode(Base.self, from: jsonData)
  }

}

public extension ALEncodableWrapper {

  func toJSONString() -> String {
    guard let data = try? JSONEncoder().encode(base) else { return "" }
    return String(data: data, encoding: .utf8) ?? ""
  }

  func toJSON() -> [String : Any] {
    var result: [String : Any] = [:]
    guard let data = try? JSONEncoder().encode(base) else { return result }

    do {
      let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
      
      if let dict = json as? [String : Any] {
        result = dict
      }
    } catch {
      return result
    }

    return result
  }

}

//public extension Array where Element: Codable {
//  static func decodeJSON(from jsonString: String?, designatedPath: String? = nil) -> [Element?]? {
//    guard let data = jsonString?.data(using: .utf8), let jsonData = getInnerObject(inside: data, by: designatedPath),
//      let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [Any] else {
//      return nil
//    }
//    return Array.decodeJSON(from: jsonObject)
//  }
//
//  static func decodeJSON(from array: [Any]?) -> [Element?]? {
//    return array?.map({ (item) -> Element? in
//      return Element.al.decode(from: item)
//    })
//  }
//}

fileprivate func getInnerObject(inside jsonData: Data?, by designatedPath: String?) -> Data? {
  guard let _jsonData = jsonData, let paths = designatedPath?.components(separatedBy: "."), paths.count > 0 else {
    return jsonData
  }

  let jsonObject = try? JSONSerialization.jsonObject(with: _jsonData, options: .allowFragments)
  var result: Any? = jsonObject
  var abort = false
  var next = jsonObject as? [String: Any]

  paths.forEach({ (seg) in
    if seg.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" || abort {
      return
    }
    if let _next = next?[seg] {
      result = _next
      next = _next as? [String: Any]
    } else {
      abort = true
    }
  })

  guard abort == false, let resultJsonObject = result, let data = try? JSONSerialization.data(withJSONObject: resultJsonObject, options: []) else {
    return nil
  }

  return data
}

