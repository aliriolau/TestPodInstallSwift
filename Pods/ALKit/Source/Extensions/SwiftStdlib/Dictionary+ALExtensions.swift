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
//  Dictionary+ALExtensions.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2019/12/2.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import Foundation

public struct ALDictionaryWrapper {
  public typealias DictionaryType = Dictionary<String, Any>
  public let base: DictionaryType
  init(_ base: DictionaryType) {
    self.base = base
  }
}

public extension Dictionary where Key == String, Value: Any {
  static var al: ALDictionaryWrapper.Type {
    get { return ALDictionaryWrapper.self }
    set { }
  }

  var al: ALDictionaryWrapper {
    get { return ALDictionaryWrapper(self) }
    set { }
  }

  /// Remove all keys contained in the keys parameter from the dictionary.
  ///
  ///        var dict : [String: String] = ["key1" : "value1", "key2" : "value2", "key3" : "value3"]
  ///        dict.removeAll(keys: ["key1", "key2"])
  ///        dict.keys.contains("key3") -> true
  ///        dict.keys.contains("key1") -> false
  ///        dict.keys.contains("key2") -> false
  ///
  /// - Parameter keys: keys to be removed
  mutating func removeAll<S: Sequence>(keys: S) where S.Element == String {
    keys.forEach { removeValue(forKey: $0) }
  }

  /// Remove a value for a random key from the dictionary.
  @discardableResult
  mutating func removeValueForRandomKey() -> Any? {
    guard let randomKey = keys.randomElement() else { return nil }
    return removeValue(forKey: randomKey)
  }

}

public extension ALDictionaryWrapper {

  func has(key: String) -> Bool {
    return base.index(forKey: key) != nil
  }

  func jsonData(prettify: Bool = false) -> Data? {
    guard JSONSerialization.isValidJSONObject(base) else {
      return nil
    }
    let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
    return try? JSONSerialization.data(withJSONObject: base, options: options)
  }

  func jsonString(prettify: Bool = false) -> String? {
    guard JSONSerialization.isValidJSONObject(base) else { return nil }
    let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
    guard let jsonData = try? JSONSerialization.data(withJSONObject: base, options: options) else { return nil }
    return String(data: jsonData, encoding: .utf8)
  }

  /// Returns a dictionary containing the results of mapping the given closure over the sequence’s elements.
  /// - Parameter transform: A mapping closure. `transform` accepts an element of this sequence as its parameter and returns a transformed value of the same or of a different type.
  /// - Returns: A dictionary containing the transformed elements of this sequence.
  func mapKeysAndValues<K, V>(_ transform: ((key: String, value: Any)) throws -> (K, V)) rethrows -> [K: V] {
    return [K: V](uniqueKeysWithValues: try base.map(transform))
  }

  /// Returns a dictionary containing the non-`nil` results of calling the given transformation with each element of this sequence.
  /// - Parameter transform: A closure that accepts an element of this sequence as its argument and returns an optional value.
  /// - Returns: A dictionary of the non-`nil` results of calling `transform` with each element of the sequence.
  /// - Complexity: *O(m + n)*, where _m_ is the length of this sequence and _n_ is the length of the result.
  func compactMapKeysAndValues<K, V>(_ transform: ((key: String, value: Any)) throws -> (K, V)?) rethrows -> [K: V] {
    return [K: V](uniqueKeysWithValues: try base.compactMap(transform))
  }

}

public extension Dictionary {

  /// Deep fetch or set a value from nested dictionaries.
  ///
  ///        var dict =  ["key": ["key1": ["key2": "value"]]]
  ///        dict[path: ["key", "key1", "key2"]] = "newValue"
  ///        dict[path: ["key", "key1", "key2"]] -> "newValue"
  ///
  /// - Note: Value fetching is iterative, while setting is recursive.
  ///
  /// - Complexity: O(N), _N_ being the length of the path passed in.
  ///
  /// - Parameter path: An array of keys to the desired value.
  ///
  /// - Returns: The value for the key-path passed in. `nil` if no value is found.
  subscript(path path: [Key]) -> Any? {
    get {
      guard !path.isEmpty else { return nil }
      var result: Any? = self
      for key in path {
        if let element = (result as? [Key: Any])?[key] {
          result = element
        } else {
          return nil
        }
      }
      return result
    }
    set {
      if let first = path.first {
        if path.count == 1, let new = newValue as? Value {
          return self[first] = new
        }
        if var nested = self[first] as? [Key: Any] {
          nested[path: Array(path.dropFirst())] = newValue
          return self[first] = nested as? Value
        }
      }
    }
  }
}

// MARK: - Operators

public extension Dictionary {

  /// Merge the keys/values of two dictionaries.
  ///
  ///        let dict: [String: String] = ["key1": "value1"]
  ///        let dict2: [String: String] = ["key2": "value2"]
  ///        let result = dict + dict2
  ///        result["key1"] -> "value1"
  ///        result["key2"] -> "value2"
  ///
  /// - Parameters:
  ///   - lhs: dictionary
  ///   - rhs: dictionary
  /// - Returns: An dictionary with keys and values from both.
  static func + (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
    var result = lhs
    rhs.forEach { result[$0] = $1 }
    return result
  }

  // MARK: - Operators

  /// Append the keys and values from the second dictionary into the first one.
  ///
  ///        var dict: [String: String] = ["key1": "value1"]
  ///        let dict2: [String: String] = ["key2": "value2"]
  ///        dict += dict2
  ///        dict["key1"] -> "value1"
  ///        dict["key2"] -> "value2"
  ///
  /// - Parameters:
  ///   - lhs: dictionary
  ///   - rhs: dictionary
  static func += (lhs: inout [Key: Value], rhs: [Key: Value]) {
    rhs.forEach { lhs[$0] = $1}
  }

  /// Remove keys contained in the sequence from the dictionary
  ///
  ///        let dict: [String: String] = ["key1": "value1", "key2": "value2", "key3": "value3"]
  ///        let result = dict-["key1", "key2"]
  ///        result.keys.contains("key3") -> true
  ///        result.keys.contains("key1") -> false
  ///        result.keys.contains("key2") -> false
  ///
  /// - Parameters:
  ///   - lhs: dictionary
  ///   - rhs: array with the keys to be removed.
  /// - Returns: a new dictionary with keys removed.
  static func - <S: Sequence>(lhs: [String: Value], keys: S) -> [String: Value] where S.Element == String {
    var result = lhs
    result.removeAll(keys: keys)
    return result
  }

  /// Remove keys contained in the sequence from the dictionary
  ///
  ///        var dict: [String: String] = ["key1": "value1", "key2": "value2", "key3": "value3"]
  ///        dict-=["key1", "key2"]
  ///        dict.keys.contains("key3") -> true
  ///        dict.keys.contains("key1") -> false
  ///        dict.keys.contains("key2") -> false
  ///
  /// - Parameters:
  ///   - lhs: dictionary
  ///   - rhs: array with the keys to be removed.
  static func -= <S: Sequence>(lhs: inout [String: Value], keys: S) where S.Element == String {
    lhs.removeAll(keys: keys)
  }

}

public extension ALStringWrapper {

  func toJSON() -> ALDictionaryWrapper.DictionaryType? {
    guard let data = base.data(using: .utf8) else { return nil }

    guard let json = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? ALDictionaryWrapper.DictionaryType else {
      return nil
    }

    return json
  }

}
