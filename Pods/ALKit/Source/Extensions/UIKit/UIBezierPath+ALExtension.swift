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
//  UIBezierPath+ALExtension.swift
//  ALAppCodesSwift
//
//  Created by Alirio-Lau on 2019/12/1.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import UIKit

// MARK: - Initializers
public extension UIBezierPath {

  convenience init(from: CGPoint, to otherPoint: CGPoint) {
    self.init()
    move(to: from)
    addLine(to: otherPoint)
  }

  /// Initializes a UIBezierPath connecting the given CGPoints with straight lines.
  ///
  /// - Parameter points: The points of which the path should consist.
  convenience init(points: [CGPoint]) {
    self.init()
    if !points.isEmpty {
      move(to: points[0])
      for point in points[1...] {
        addLine(to: point)
      }
    }
  }

  /// Initializes a polygonal UIBezierPath with the given CGPoints. At least 3 points must be given.
  ///
  /// - Parameter points: The points of the polygon which the path should form.
  convenience init?(polygonWithPoints points: [CGPoint]) {
    guard points.count > 2 else {return nil}
    self.init()
    move(to: points[0])
    for point in points[1...] {
      addLine(to: point)
    }
    close()
  }

  /// Initializes a UIBezierPath with an oval path of given size.
  ///
  /// - Parameters:
  ///   - size: The width and height of the oval.
  ///   - centered: Whether the oval should be centered in its coordinate space.
  convenience init(ovalOf size: CGSize, centered: Bool) {
    let origin = centered ? CGPoint(x: -size.width / 2, y: -size.height / 2) : .zero
    self.init(ovalIn: CGRect(origin: origin, size: size))
  }

  /// Initializes a UIBezierPath with a  rectangular path of given size.
  ///
  /// - Parameters:
  ///   - size: The width and height of the rect.
  ///   - centered: Whether the oval should be centered in its coordinate space.
  convenience init(rectOf size: CGSize, centered: Bool) {
    let origin = centered ? CGPoint(x: -size.width / 2, y: -size.height / 2) : .zero
    self.init(rect: CGRect(origin: origin, size: size))
  }

}
