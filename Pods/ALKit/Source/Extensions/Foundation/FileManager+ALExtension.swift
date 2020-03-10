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
//  FileManager+ALExtension.swift
//  ALAppCodesSwift
//
//  Created by Alirio-Lau on 2019/12/1.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import Foundation

public extension ALWrapper where Base == FileManager {

  func jsonFromFile(
    atPath path: String,
    readingOptions: JSONSerialization.ReadingOptions = .allowFragments
  ) throws -> [String: Any]? {

    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    let json = try JSONSerialization.jsonObject(with: data, options: readingOptions)

    return json as? [String: Any]
  }

  /// Read from a JSON file with a given filename.
  ///
  /// - Parameters:
  ///   - filename: File to read.
  ///   - bundleClass: Bundle where the file is associated.
  ///   - readingOptions: JSONSerialization reading options.
  /// - Returns: Optional dictionary.
  /// - Throws: Throws any errors thrown by Data creation or JSON serialization.
  func jsonFromFile(
    withFilename filename: String,
    at bundleClass: AnyClass? = nil,
    readingOptions: JSONSerialization.ReadingOptions = .allowFragments
  ) throws -> [String: Any]? {
    // https://stackoverflow.com/questions/24410881/reading-in-a-json-file-using-swift

    // To handle cases that provided filename has an extension
    let name = filename.components(separatedBy: ".")[0]
    let bundle = bundleClass != nil ? Bundle(for: bundleClass!) : Bundle.main

    if let path = bundle.path(forResource: name, ofType: "json") {
      let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
      let json = try JSONSerialization.jsonObject(with: data, options: readingOptions)

      return json as? [String: Any]
    }

    return nil
  }

  /// Creates a unique directory for saving temporary files. The directory can be used to create multiple temporary files used for a common purpose.
  ///
  ///     let tempDirectory = try fileManager.createTemporaryDirectory()
  ///     let tempFile1URL = tempDirectory.appendingPathComponent(ProcessInfo().globallyUniqueString)
  ///     let tempFile2URL = tempDirectory.appendingPathComponent(ProcessInfo().globallyUniqueString)
  ///
  /// - Returns: A URL to a new directory for saving temporary files.
  /// - Throws: An error if a temporary directory cannot be found or created.
  func createTemporaryDirectory() throws -> URL {
    let temporaryDirectoryURL: URL
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
      temporaryDirectoryURL = base.temporaryDirectory
    } else {
      temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
    }
    return try base.url(for: .itemReplacementDirectory,
                        in: .userDomainMask,
                        appropriateFor: temporaryDirectoryURL,
                        create: true)
  }

}
