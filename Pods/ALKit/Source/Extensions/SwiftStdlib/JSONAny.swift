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
//  JSONAny.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2020/1/8.
//  Copyright © 2020 com.alirio.lau.www. All rights reserved.
//

import Foundation

class JSONAny: Codable {
  public let value: Any

  init() { value = "" }

  typealias CodingKeyType = _JSONAnyCodingKey

  public required init(from decoder: Decoder) throws {
    if var arrayContainer = try? decoder.unkeyedContainer() {
      value = try JSONAny.decodeArray(from: &arrayContainer)
    } else if var container = try? decoder.container(keyedBy: CodingKeyType.self) {
      value = try JSONAny.decodeDictionary(from: &container)
    } else {
      let container = try decoder.singleValueContainer()
      value = try JSONAny.decode(from: container)
    }
  }

  public func encode(to encoder: Encoder) throws {
    if let array = value as? [Any] {
      var container = encoder.unkeyedContainer()
      try JSONAny.encode(to: &container, array: array)
    } else if let dict = value as? [String: Any] {
      var container = encoder.container(keyedBy: CodingKeyType.self)
      try JSONAny.encode(to: &container, dictionary: dict)
    } else {
      var container = encoder.singleValueContainer()
      try JSONAny.encode(to: &container, value: value)
    }
  }

  private static func decodeArray(
    from container: inout UnkeyedDecodingContainer
  ) throws -> [Any] {
    var arr: [Any] = []
    while !container.isAtEnd {
      let value = try decode(from: &container)
      arr.append(value)
    }
    return arr
  }

  private static func decode(
    from container: SingleValueDecodingContainer
  ) throws -> Any {
    if let value = try? container.decode(Bool.self) { return value }
    if let value = try? container.decode(Int.self) { return value }
    if let value = try? container.decode(Double.self) { return value }
    if let value = try? container.decode(String.self) { return value }
    if container.decodeNil() { return JSONNull() }
    throw decodingError(forCodingPath: container.codingPath)
  }

  private static func decode(
    from container: inout UnkeyedDecodingContainer
  ) throws -> Any {
    if let value = try? container.decode(Bool.self) { return value }
    if let value = try? container.decode(Int.self) { return value }
    if let value = try? container.decode(Double.self) { return value }
    if let value = try? container.decode(String.self) { return value }
    if let value = try? container.decodeNil() { if value { return JSONNull() } }
    if var container = try? container.nestedUnkeyedContainer() {
      return try decodeArray(from: &container)
    }
    if var container = try? container.nestedContainer(keyedBy: CodingKeyType.self) {
      return try decodeDictionary(from: &container)
    }
    throw decodingError(forCodingPath: container.codingPath)
  }

  private static func decode<Key: CodingKey>(
    from container: inout KeyedDecodingContainer<Key>,
    forKey key: Key
  ) throws -> Any {
    if let value = try? container.decode(Bool.self, forKey: key) { return value }
    if let value = try? container.decode(Int.self, forKey: key) { return value }
    if let value = try? container.decode(Double.self, forKey: key) { return value }
    if let value = try? container.decode(String.self, forKey: key) { return value }
    if let value = try? container.decodeNil(forKey: key) { if value { return JSONNull() } }
    if var container = try? container.nestedUnkeyedContainer(forKey: key) {
      return try decodeArray(from: &container)
    }
    if var container = try? container.nestedContainer(keyedBy: Key.self, forKey: key) {
      return try decodeDictionary(from: &container)
    }
    throw decodingError(forCodingPath: container.codingPath)
  }

  private static func decodeDictionary<Key: CodingKey>(
    from container: inout KeyedDecodingContainer<Key>
  ) throws -> [String: Any] {
    var dict = [String: Any]()
    for key in container.allKeys {
      let value = try decode(from: &container, forKey: key)
      dict[key.stringValue] = value
    }
    return dict
  }

  private static func encode(
    to container: inout UnkeyedEncodingContainer,
    array: [Any]
  ) throws {
    for value in array {
      if let value = value as? Bool {
        try container.encode(value)
      } else if let value = value as? Int {
        try container.encode(value)
      } else if let value = value as? Double {
        try container.encode(value)
      } else if let value = value as? String {
        try container.encode(value)
      } else if value is JSONNull {
        try container.encodeNil()
      } else if let value = value as? [Any] {
        var container = container.nestedUnkeyedContainer()
        try encode(to: &container, array: value)
      } else if let value = value as? [String: Any] {
        var container = container.nestedContainer(keyedBy: CodingKeyType.self)
        try encode(to: &container, dictionary: value)
      } else {
        throw encodingError(forValue: value, codingPath: container.codingPath)
      }
    }
  }

  private static func encode<Key: CodingKey>(
    to container: inout KeyedEncodingContainer<Key>,
    dictionary: [String: Any]
  ) throws {
    for (key, value) in dictionary {
      let key = Key(stringValue: key)!
      if let value = value as? Bool {
        try container.encode(value, forKey: key)
      } else if let value = value as? Int {
        try container.encode(value, forKey: key)
      } else if let value = value as? Double {
        try container.encode(value, forKey: key)
      } else if let value = value as? String {
        try container.encode(value, forKey: key)
      } else if value is JSONNull {
        try container.encodeNil(forKey: key)
      } else if let value = value as? [Any] {
        var container = container.nestedUnkeyedContainer(forKey: key)
        try encode(to: &container, array: value)
      } else if let value = value as? [String: Any] {
        var container = container.nestedContainer(keyedBy: Key.self, forKey: key)
        try encode(to: &container, dictionary: value)
      } else {
        throw encodingError(forValue: value, codingPath: container.codingPath)
      }
    }
  }

  private static func encode(
    to container: inout SingleValueEncodingContainer,
    value: Any
  ) throws {
    if let value = value as? Bool {
      try container.encode(value)
    } else if let value = value as? Int {
      try container.encode(value)
    } else if let value = value as? Double {
      try container.encode(value)
    } else if let value = value as? String {
      try container.encode(value)
    } else if value is JSONNull {
      try container.encodeNil()
    } else {
      throw encodingError(forValue: value, codingPath: container.codingPath)
    }
  }

  private static func decodingError(
    forCodingPath codingPath: [CodingKey]
  ) -> DecodingError {
    let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
    return DecodingError.typeMismatch(JSONAny.self, context)
  }

  private static func encodingError(
    forValue value: Any, codingPath: [CodingKey]
  ) -> EncodingError {
    let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
    return EncodingError.invalidValue(value, context)
  }

  class JSONNull: Codable {
    public init() { }

    public required init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      if !container.decodeNil() {
        throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
      }
    }

    public func encode(to encoder: Encoder) throws {
      var container = encoder.singleValueContainer()
      try container.encodeNil()
    }
  }

  class _JSONAnyCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) { return nil }
    required init?(stringValue: String) { key = stringValue }

    var intValue: Int? { return nil }
    var stringValue: String { return key}
  }

}
