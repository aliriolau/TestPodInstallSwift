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
//  CheckBox.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2019/12/5.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import UIKit

open class CheckBox: UIControl {

  public enum Style {
    /// ■
    case square
    /// ●
    case circle
    /// x
    case cross
    /// ✓
    case tick
  }

  public enum BorderStyle {
    /// ■
    case square
    /// ▢
    case roundedSquare(radius: CGFloat)
    /// ◯
    case rounded
  }

  var style = Style.tick
  var borderStyle = BorderStyle.rounded
  var borderWidth = CGFloat(1.75)

  var uncheckedBackgroundColor = UIColor.white
  var checkedBackgroundColor = UIColor.white

  var uncheckedBorderColor: UIColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
  var checkedBorderColor: UIColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)

  var checkmarkColor: UIColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)

  var increasedTouchRadius = CGFloat(5)
  var useHapticFeedback = true

  var isChecked = false {
    didSet {
      setNeedsDisplay()
    }
  }

  private var feedbackGenerator: UIImpactFeedbackGenerator?

  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupViews()
  }

  private func setupViews() {
    backgroundColor = .clear
  }

  open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)

    if #available(iOS 10.0, *) {
      feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
      feedbackGenerator?.prepare()
    }
  }

  open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    isChecked = !isChecked
    sendActions(for: .valueChanged)
    if useHapticFeedback {
      if #available(iOS 10.0, *) {
        feedbackGenerator?.impactOccurred()
        feedbackGenerator = nil
      }
    }
  }

  open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    let relativeFrame = bounds
    let hitTestEdgeInsets = UIEdgeInsets(top: -increasedTouchRadius, left: -increasedTouchRadius, bottom: -increasedTouchRadius, right: -increasedTouchRadius)
    let hitFrame = relativeFrame.inset(by: hitTestEdgeInsets)
    return hitFrame.contains(point)
  }

  open override func draw(_ rect: CGRect) {
    let insetOffset = borderWidth * 0.5
    let newRect = rect.insetBy(dx: insetOffset, dy: insetOffset)
    let innerRect = newRect.insetBy(dx: insetOffset, dy: insetOffset)

    guard let context = UIGraphicsGetCurrentContext() else {
      return
    }
    context.setLineWidth(borderWidth)

    var borderPath: UIBezierPath!
    var innerPath: UIBezierPath!

    switch borderStyle {
    case .square:
      borderPath = UIBezierPath(rect: newRect)
      innerPath = UIBezierPath(rect: innerRect)
    case .roundedSquare(let radius):
      borderPath = UIBezierPath(roundedRect: newRect, cornerRadius: radius)
      innerPath = UIBezierPath(roundedRect: innerRect, cornerRadius: radius)
    case .rounded:
      borderPath = UIBezierPath(ovalIn: newRect)
      innerPath = UIBezierPath(ovalIn: innerRect)
    }

    context.addPath(borderPath.cgPath)
    context.setStrokeColor(isChecked ? checkedBorderColor.cgColor : uncheckedBorderColor.cgColor)
    context.strokePath()

    context.addPath(innerPath.cgPath)
    context.setFillColor(isChecked ? checkedBackgroundColor.cgColor : uncheckedBackgroundColor.cgColor)
    context.fillPath()

    if isChecked {
      switch style {
      case .square:
        drawInnerSquare(frame: newRect)
      case .circle:
        drawCircle(frame: newRect)
      case .cross:
        drawCross(frame: newRect)
      case .tick:
        drawCheckMark(frame: newRect)
      }
    }
  }

  open override func layoutSubviews() {
    super.layoutSubviews()
    setNeedsDisplay()
  }

  open override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    setNeedsDisplay()
  }

  //Draws tick inside the component
  private func drawCheckMark(frame: CGRect) {

    //// Bezier Drawing
    /**
    let bezierPath = UIBezierPath()
    bezierPath.move(to: CGPoint(x: frame.minX + 0.26000 * frame.width, y: frame.minY + 0.50000 * frame.height))
    bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.42000 * frame.width, y: frame.minY + 0.62000 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.38000 * frame.width, y: frame.minY + 0.60000 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.42000 * frame.width, y: frame.minY + 0.62000 * frame.height))
    bezierPath.addLine(to: CGPoint(x: frame.minX + 0.70000 * frame.width, y: frame.minY + 0.24000 * frame.height))
    bezierPath.addLine(to: CGPoint(x: frame.minX + 0.78000 * frame.width, y: frame.minY + 0.30000 * frame.height))
    bezierPath.addLine(to: CGPoint(x: frame.minX + 0.44000 * frame.width, y: frame.minY + 0.76000 * frame.height))
    bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.20000 * frame.width, y: frame.minY + 0.58000 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.44000 * frame.width, y: frame.minY + 0.76000 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.26000 * frame.width, y: frame.minY + 0.62000 * frame.height))
    checkmarkColor.setFill()
    bezierPath.fill()
     */

    let bezierPath = UIBezierPath()
    bezierPath.lineCapStyle = .round
    bezierPath.lineJoinStyle = .round
    bezierPath.lineWidth = 3

    bezierPath.move(to: CGPoint(x: frame.size.width * 0.25, y: frame.size.height*0.55))
    bezierPath.addLine(to: CGPoint(x: frame.size.width * 0.46, y: frame.size.height*0.75))
    bezierPath.addLine(to: CGPoint(x: frame.size.width * 0.79, y: frame.size.height*0.34))

    checkmarkColor.setStroke()
    bezierPath.stroke()
  }

  //Draws circle inside the component
  private func drawCircle(frame: CGRect) {
    func fastFloor(_ x: CGFloat) -> CGFloat { return floor(x) }

    let ovalPath = UIBezierPath(ovalIn: CGRect(x: frame.minX + fastFloor(frame.width * 0.22000 + 0.5), y: frame.minY + fastFloor(frame.height * 0.22000 + 0.5), width: fastFloor(frame.width * 0.76000 + 0.5) - fastFloor(frame.width * 0.22000 + 0.5), height: fastFloor(frame.height * 0.78000 + 0.5) - fastFloor(frame.height * 0.22000 + 0.5)))
    checkmarkColor.setFill()
    ovalPath.fill()
  }

  //Draws square inside the component
  private func drawInnerSquare(frame: CGRect) {
    func fastFloor(_ x: CGFloat) -> CGFloat { return floor(x) }

    //// Rectangle Drawing
    let padding = self.bounds.width * 0.3
    let innerRect = frame.inset(by: .init(top: padding, left: padding, bottom: padding, right: padding))
    let rectanglePath = UIBezierPath(roundedRect: innerRect, cornerRadius: 3)

    checkmarkColor.setFill()
    rectanglePath.fill()
  }

  //Draws cross inside the component
  func drawCross(frame: CGRect) {
    //// General Declarations
    let context = UIGraphicsGetCurrentContext()!
    // This non-generic function dramatically improves compilation times of complex expressions.
    func fastFloor(_ x: CGFloat) -> CGFloat { return floor(x) }

    //// Subframes
    let group: CGRect = CGRect(x: frame.minX + fastFloor((frame.width - 17.37) * 0.49035 + 0.5), y: frame.minY + fastFloor((frame.height - 23.02) * 0.51819 - 0.48) + 0.98, width: 17.37, height: 23.02)

    //// Group
    //// Rectangle Drawing
    context.saveGState()
    context.translateBy(x: group.minX + 14.91, y: group.minY)
    context.rotate(by: 35 * CGFloat.pi/180)

    let rectanglePath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 3, height: 26))
    checkmarkColor.setFill()
    rectanglePath.fill()

    context.restoreGState()

    //// Rectangle 2 Drawing
    context.saveGState()
    context.translateBy(x: group.minX, y: group.minY + 1.72)
    context.rotate(by: -35 * CGFloat.pi/180)

    let rectangle2Path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 3, height: 26))
    checkmarkColor.setFill()
    rectangle2Path.fill()

    context.restoreGState()
  }

}
