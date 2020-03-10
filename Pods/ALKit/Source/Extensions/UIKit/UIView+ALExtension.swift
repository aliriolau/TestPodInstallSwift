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
//  UIView+ALExtension.swift
//  ALAppCodesSwift
//
//  Created by Alirio-Lau on 2019/12/1.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import UIKit

// MARK: - Properties

public extension ALWrapper where Base: UIView {

  var x: CGFloat {
    get { return base.frame.origin.x }
    set { base.frame.origin.x = newValue }
  }

  var y: CGFloat {
    get { return base.frame.origin.y }
    set { base.frame.origin.y = newValue }
  }

  var width: CGFloat {
    get { return  base.frame.size.width }
    set {  base.frame.size.width = newValue }
  }

  var height: CGFloat {
    get { return base.frame.size.height }
    set { base.frame.size.height = newValue }
  }

  var size: CGSize {
    get { return base.frame.size }
    set { width = newValue.width; height = newValue.height }
  }

  var origin: CGPoint {
    get { return base.frame.origin }
    set { x = newValue.x; y = newValue.y }
  }

  var centerX: CGFloat {
    return (base.frame.origin.x + base.frame.size.width) / 2
  }

  var centerY: CGFloat {
    return (base.frame.origin.y + base.frame.size.height) / 2
  }

  var screenshot: UIImage? {
    UIGraphicsBeginImageContextWithOptions(base.layer.frame.size, false, 0)
    defer { UIGraphicsEndImageContext() }
    guard let context = UIGraphicsGetCurrentContext() else { return nil }
    base.layer.render(in: context)
    return UIGraphicsGetImageFromCurrentImageContext()
  }

  // MARK: - Animation

  enum ShakeDirection {
    case horizontal
    case vertical
  }

  enum AngleUnit {
    case degrees
    case radians
  }

  enum ShakeAnimationType {
    case linear
    case easeIn
    case easeOut
    case easeInOut
  }

  func rotate(
    byAngle angle: CGFloat,
    ofType type: AngleUnit,
    animated: Bool = false,
    duration: TimeInterval = 1,
    completion: ((Bool) -> Void)? = nil
  ) {
    let angleWithType = (type == .degrees) ? .pi * angle / 180.0 : angle
    let aDuration = animated ? duration : 0
    UIView.animate(withDuration: aDuration, delay: 0, options: .curveLinear, animations: { () -> Void in
      self.base.transform = self.base.transform.rotated(by: angleWithType)
    }, completion: completion)
  }

  func rotate(
    toAngle angle: CGFloat,
    ofType type: AngleUnit,
    animated: Bool = false,
    duration: TimeInterval = 1,
    completion: ((Bool) -> Void)? = nil
  ) {
    let angleWithType = (type == .degrees) ? .pi * angle / 180.0 : angle
    let aDuration = animated ? duration : 0
    UIView.animate(withDuration: aDuration, animations: {
      self.base.transform = self.base.transform.concatenating(CGAffineTransform(rotationAngle: angleWithType))
    }, completion: completion)
  }

  func shake(
    direction: ShakeDirection = .horizontal,
    duration: TimeInterval = 1,
    animationType: ShakeAnimationType = .easeOut,
    completion:(() -> Void)? = nil
  ) {
    CATransaction.begin()
    let animation: CAKeyframeAnimation
    switch direction {
    case .horizontal:
      animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
    case .vertical:
      animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
    }
    switch animationType {
    case .linear:
      animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
    case .easeIn:
      animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
    case .easeOut:
      animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
    case .easeInOut:
      animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    }
    CATransaction.setCompletionBlock(completion)
    animation.duration = duration
    animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
    base.layer.add(animation, forKey: "shake")
    CATransaction.commit()
  }

}

// MARK: - Methods

public extension ALWrapper where Base: UIView {

  func subviews<T>(ofType type: T.Type) -> [T] {
    base.subviews.compactMap { $0 as? T }
  }

  func firstResponder() -> UIView? {
    var views = [UIView](arrayLiteral: base)
    var index = 0
    repeat {
      let view = views[index]
      if view.isFirstResponder {
        return view
      }
      views.append(contentsOf: view.subviews)
      index += 1
    } while index < views.count
    
    return nil
  }

  func roundCorners(_ corners: UIRectCorner = [.allCorners], radius: CGFloat) {
    if #available(iOS 11, *) {
      var cornerMask: CACornerMask = []
      if corners.contains(.allCorners) {
        cornerMask = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
      } else {
        if corners.contains(.bottomLeft) {
          cornerMask.update(with: .layerMinXMaxYCorner)
        }
        if corners.contains(.bottomRight) {
          cornerMask.update(with: .layerMaxXMaxYCorner)
        }
        if corners.contains(.topLeft) {
          cornerMask.update(with: .layerMinXMinYCorner)
        }
        if corners.contains(.topRight) {
          cornerMask.update(with: .layerMaxXMinYCorner)
        }
      }

      base.layer.cornerRadius = radius
      base.layer.masksToBounds = true
      base.layer.maskedCorners = cornerMask
    } else {
      let maskPath = UIBezierPath(
        roundedRect: base.bounds,
        byRoundingCorners: corners,
        cornerRadii: CGSize(width: radius, height: radius)
      )

      let shape = CAShapeLayer()
      shape.path = maskPath.cgPath
      base.layer.mask = shape
    }
  }

  func addShadow(
    ofColor color: UIColor = UIColor(red: 0.07, green: 0.47, blue: 0.57, alpha: 1.0),
    radius: CGFloat = 3,
    offset: CGSize = .zero,
    opacity: Float = 0.5
  ) {
    base.layer.shadowColor = color.cgColor
    base.layer.shadowOffset = offset
    base.layer.shadowRadius = radius
    base.layer.shadowOpacity = opacity
    base.layer.masksToBounds = false
  }

  func addSubviews(_ subviews: [UIView]) {
    base.subviews.forEach { base.addSubview($0) }
  }

  func fadeIn(duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
    if base.isHidden {
      base.isHidden = false
    }
    UIView.animate(withDuration: duration, animations: {
      self.base.alpha = 1
    }, completion: completion)
  }

  func fadeOut(duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
    if base.isHidden {
      base.isHidden = false
    }
    UIView.animate(withDuration: duration, animations: {
      self.base.alpha = 0
    }, completion: completion)
  }

  func removeSubviews() {
    base.subviews.forEach({ $0.removeFromSuperview() })
  }

  func removeGestureRecognizers() {
    base.gestureRecognizers?.forEach(base.removeGestureRecognizer)
  }

  func addGestureRecognizers(_ gestureRecognizers: [UIGestureRecognizer]) {
    for recognizer in gestureRecognizers {
      base.addGestureRecognizer(recognizer)
    }
  }

  func removeGestureRecognizers(_ gestureRecognizers: [UIGestureRecognizer]) {
    for recognizer in gestureRecognizers {
      base.removeGestureRecognizer(recognizer)
    }
  }

  func scale(
    by offset: CGPoint,
    animated: Bool = false,
    duration: TimeInterval = 1,
    completion: ((Bool) -> Void)? = nil
  ) {
    if animated {
      UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: { () -> Void in
        self.base.transform = self.base.transform.scaledBy(x: offset.x, y: offset.y)
      }, completion: completion)
    } else {
      base.transform = base.transform.scaledBy(x: offset.x, y: offset.y)
      completion?(true)
    }
  }

  @available(iOS 9, *)
  func fillToSuperview() {
    base.translatesAutoresizingMaskIntoConstraints = false
    if let superview = base.superview {
      let left = base.leftAnchor.constraint(equalTo: superview.leftAnchor)
      let right = base.rightAnchor.constraint(equalTo: superview.rightAnchor)
      let top = base.topAnchor.constraint(equalTo: superview.topAnchor)
      let bottom = base.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
      NSLayoutConstraint.activate([left, right, top, bottom])
    }
  }

  @available(iOS 9, *)
  func anchorCenterXToSuperview(constant: CGFloat = 0) {
    base.translatesAutoresizingMaskIntoConstraints = false
    if let anchor = base.superview?.centerXAnchor {
      base.centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
    }
  }

  @available(iOS 9, *)
  func anchorCenterYToSuperview(constant: CGFloat = 0) {
    base.translatesAutoresizingMaskIntoConstraints = false
    if let anchor = base.superview?.centerYAnchor {
      base.centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
    }
  }

  @available(iOS 9, *)
  func anchorCenterSuperview() {
    anchorCenterXToSuperview()
    anchorCenterYToSuperview()
  }

  func ancestorView(where predicate: (UIView?) -> Bool) -> UIView? {
    if predicate(base.superview) {
      return base.superview
    }
    return base.superview?.al.ancestorView(where: predicate)
  }

  func ancestorView<T: UIView>(withClass name: T.Type) -> T? {
    return ancestorView(where: { $0 is T }) as? T
  }

}

public extension ALWrapper where Base: UIView {
  private class ALCoverView : UIView {
    let activityView = UIActivityIndicatorView(style: .whiteLarge)

    override init(frame: CGRect) {
      super.init(frame: frame)
      setup()
    }

    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      setup()
    }

    func setup() {
      backgroundColor = UIColor(white: 0, alpha: 0.15)
      alpha = 0
      autoresizingMask = [.flexibleWidth, .flexibleHeight]

      activityView.startAnimating()
      addSubview(activityView)
    }

    override func layoutSubviews() {
      super.layoutSubviews()
      activityView.center = center
    }
  }

  /// Covers this view
  func cover(
    duration: Double = 0.25,
    hideActivityView: Bool = false,
    completion: (() -> Void)? = nil) {
    guard subviews(ofType: ALCoverView.self).isEmpty else { return }

    let coverView = ALCoverView(frame: base.bounds)
    coverView.activityView.isHidden = hideActivityView
    base.addSubview(coverView)

    UIView.animate(withDuration: duration, animations: {
      coverView.alpha = 1
    }, completion: { _ in completion?() })
  }

  /// Uncovers this view
  func uncover(
    duration: Double = 0.25,
    completion: (() -> Void)? = nil) {
    let coverViews = subviews(ofType: ALCoverView.self)
    guard !coverViews.isEmpty else { completion?(); return }

    UIView.animate( withDuration: duration, animations: {
      coverViews.forEach { $0.alpha = 0 }
    }, completion: { (completed) -> Void in
      coverViews.forEach { $0.removeFromSuperview() }
      completion?()
    })
  }
}
