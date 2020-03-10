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
//  Array+ALExtensions.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2019/12/3.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import Foundation

public struct ALArrayWrapper<Element: Any> {
  public typealias ALArrayWrapperType = Array<Element>
  public let base: ALArrayWrapperType
  init(_ base: ALArrayWrapperType) {
    self.base = base
  }
}

extension Array {
  static var al: ALArrayWrapper<Element>.Type {
    get { return ALArrayWrapper<Element>.self }
    set { }
  }

  var al: ALArrayWrapper<Element> {
    get { return ALArrayWrapper<Element>(self) }
    set { }
  }

  /// Safely swap values at given index positions.
  ///
  ///        [1, 2, 3, 4, 5].safeSwap(from: 3, to: 0) -> [4, 2, 3, 1, 5]
  ///        ["h", "e", "l", "l", "o"].safeSwap(from: 1, to: 0) -> ["e", "h", "l", "l", "o"]
  ///
  /// - Parameters:
  ///   - index: index of first element.
  ///   - otherIndex: index of other element.
  mutating func safeSwap(from index: Int, to otherIndex: Int) {
    guard index != otherIndex else { return }
    guard startIndex..<endIndex ~= index else { return }
    guard startIndex..<endIndex ~= otherIndex else { return }
    swapAt(index, otherIndex)
  }
}

extension Array where Element: Equatable {

  /// Remove all instances of an item from array.
  ///
  ///        [1, 2, 2, 3, 4, 5].removeAll(2) -> [1, 3, 4, 5]
  ///        ["h", "e", "l", "l", "o"].removeAll("l") -> ["h", "e", "o"]
  ///
  /// - Parameter item: item to remove.
  /// - Returns: self after removing all instances of item.
  @discardableResult
  mutating func removeAll(_ item: Element) -> [Element] {
    removeAll(where: { $0 == item })
    return self
  }

  /// Remove all instances contained in items parameter from array.
  ///
  ///        [1, 2, 2, 3, 4, 5].removeAll([2,5]) -> [1, 3, 4]
  ///        ["h", "e", "l", "l", "o"].removeAll(["l", "h"]) -> ["e", "o"]
  ///
  /// - Parameter items: items to remove.
  /// - Returns: self after removing all instances of all items in given array.
  @discardableResult
  mutating func removeAll(_ items: [Element]) -> [Element] {
    guard !items.isEmpty else { return self }
    removeAll(where: { items.contains($0) })
    return self
  }

  /// Remove all duplicate elements from Array.
  ///
  ///        [1, 2, 2, 3, 4, 5].removeDuplicates() -> [1, 2, 3, 4, 5]
  ///        ["h", "e", "l", "l", "o"]. removeDuplicates() -> ["h", "e", "l", "o"]
  ///
  /// - Returns: Return array with all duplicate elements removed.
  @discardableResult
  mutating func removeDuplicates() -> [Element] {
    // Thanks to https://github.com/sairamkotha for improving the method
    self = reduce(into: [Element]()) {
      if !$0.contains($1) {
        $0.append($1)
      }
    }
    return self
  }

}

public extension ALArrayWrapper where Element: Equatable {

  /// Return array with all duplicate elements removed.
  ///
  ///     [1, 1, 2, 2, 3, 3, 3, 4, 5].withoutDuplicates() -> [1, 2, 3, 4, 5])
  ///     ["h", "e", "l", "l", "o"].withoutDuplicates() -> ["h", "e", "l", "o"])
  ///
  /// - Returns: an array of unique elements.
  ///
  func withoutDuplicates() -> [Element] {
    // Thanks to https://github.com/sairamkotha for improving the method
    return base.reduce(into: [Element]()) {
      if !$0.contains($1) {
        $0.append($1)
      }
    }
  }

  /// Returns an array with all duplicate elements removed using KeyPath to compare.
  ///
  /// - Parameter path: Key path to compare, the value must be Equatable.
  /// - Returns: an array of unique elements.
  func withoutDuplicates<E: Equatable>(keyPath path: KeyPath<Element, E>) -> [Element] {
    return base.reduce(into: [Element]()) { (result, element) in
      if !result.contains { $0[keyPath: path] == element[keyPath: path] } {
        result.append(element)
      }
    }
  }

  /// Returns an array with all duplicate elements removed using KeyPath to compare.
  ///
  /// - Parameter path: Key path to compare, the value must be Hashable.
  /// - Returns: an array of unique elements.
  func withoutDuplicates<E: Hashable>(keyPath path: KeyPath<Element, E>) -> [Element] {
    var set = Set<E>()
    return base.filter { set.insert($0[keyPath: path]).inserted }
  }
}
