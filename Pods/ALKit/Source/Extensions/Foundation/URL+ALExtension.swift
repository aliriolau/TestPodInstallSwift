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
//  URL+ALExtension.swift
//  ALAppCodesSwift
//
//  Created by Alirio-Lau on 2019/12/1.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import UIKit
import AVFoundation

public struct ALURLWrapper<URLType> {
  public let base: URLType
  public init(_ base: URLType) {
    self.base = base
  }
}

public extension URL {
  var al: ALURLWrapper<Self> {
    get { return ALURLWrapper(self) }
    set { }
  }
}

// MARK: - Mutating

public extension URL {

  /// Append query parameters to URL.
  ///
  ///    var url = URL(string: "https://google.com")!
  ///    let param = ["q": "Swifter Swift"]
  ///    url.appendQueryParameters(params)
  ///    print(url) // prints "https://google.com?q=Swifter%20Swift"
  ///
  /// - Parameter parameters: parameters dictionary.
  mutating func appendQueryParameters(_ parameters: [String: String]) {
    self = self.al.appendingQueryParameters(parameters)
  }

  /// Remove all the path components from the URL.
  ///
  ///        var url = URL(string: "https://domain.com/path/other")!
  ///        url.deleteAllPathComponents()
  ///        print(url) // prints "https://domain.com/"
  mutating func deleteAllPathComponents() {
    for _ in 0..<self.pathComponents.count - 1 {
      self.deleteLastPathComponent()
    }
  }

}

public extension ALURLWrapper where URLType == URL {

  var queryParameters: [String: String]? {
    guard let components = URLComponents(url: base, resolvingAgainstBaseURL: false),
      let queryItems = components.queryItems else { return nil }

    var items: [String: String] = [:]

    for queryItem in queryItems {
      items[queryItem.name] = queryItem.value
    }

    return items
  }

  /// URL with appending query parameters.
  ///
  ///    let url = URL(string: "https://google.com")!
  ///    let param = ["q": "Swifter Swift"]
  ///    url.appendingQueryParameters(params) -> "https://google.com?q=Swifter%20Swift"
  ///
  /// - Parameter parameters: parameters dictionary.
  /// - Returns: URL with appending given query parameters.
  func appendingQueryParameters(_ parameters: [String: String]) -> URL {
    var urlComponents = URLComponents(url: base, resolvingAgainstBaseURL: true)!
    var items = urlComponents.queryItems ?? []
    items += parameters.map({ URLQueryItem(name: $0, value: $1) })
    urlComponents.queryItems = items
    return urlComponents.url!
  }

  /// Get value of a query key.
  ///
  ///    var url = URL(string: "https://google.com?code=12345")!
  ///    queryValue(for: "code") -> "12345"
  ///
  /// - Parameter key: The key of a query value.
  func queryValue(for key: String) -> String? {
    return URLComponents(string: base.absoluteString)?
      .queryItems?
      .first(where: { $0.name == key })?
      .value
  }

  /// Returns a new URL by removing all the path components.
  ///
  ///     let url = URL(string: "https://domain.com/path/other")!
  ///     print(url.deletingAllPathComponents()) // prints "https://domain.com/"
  ///
  /// - Returns: URL with all path components removed.
  func deletingAllPathComponents() -> URL {
    var url: URL = base
    for _ in 0..<base.pathComponents.count - 1 {
      url.deleteLastPathComponent()
    }
    return url
  }

  /// Generates new URL that does not have scheme.
  ///
  ///        let url = URL(string: "https://domain.com")!
  ///        print(url.droppedScheme()) // prints "domain.com"
  func droppedScheme() -> URL? {
    if let scheme = base.scheme {
      let droppedScheme = String(base.absoluteString.dropFirst(scheme.count + 3))
      return URL(string: droppedScheme)
    }

    guard base.host != nil else { return base }

    let droppedScheme = String(base.absoluteString.dropFirst(2))
    return URL(string: droppedScheme)
  }

  /// Generate a thumbnail image from given url. Returns nil if no thumbnail could be created. This function may take some time to complete. It's recommended to dispatch the call if the thumbnail is not generated from a local resource.
  ///
  ///     var url = URL(string: "https://video.golem.de/files/1/1/20637/wrkw0718-sd.mp4")!
  ///     var thumbnail = url.thumbnail()
  ///     thumbnail = url.thumbnail(fromTime: 5)
  ///
  ///     DisptachQueue.main.async {
  ///         someImageView.image = url.thumbnail()
  ///     }
  ///
  /// - Parameter time: Seconds into the video where the image should be generated.
  /// - Returns: The UIImage result of the AVAssetImageGenerator
  func thumbnail(fromTime time: Float64 = 0) -> UIImage? {
    let imageGenerator = AVAssetImageGenerator(asset: AVAsset(url: base))
    let time = CMTimeMakeWithSeconds(time, preferredTimescale: 1)
    var actualTime = CMTimeMake(value: 0, timescale: 0)

    guard let cgImage = try? imageGenerator.copyCGImage(at: time, actualTime: &actualTime) else {
      return nil
    }
    return UIImage(cgImage: cgImage)
  }

}
