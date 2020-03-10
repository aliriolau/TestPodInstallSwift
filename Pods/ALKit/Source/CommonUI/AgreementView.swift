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
//  AgreementView.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2019/12/19.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import UIKit

fileprivate struct Agreement {
  let name: NSAttributedString.Key
  let range: NSRange
  let index: Int
}

public class AgreementView: UIView {

  private let font: UIFont
  private let foregroundColor: UIColor
  private let hightlightedColor: UIColor

  private let touchItemAttributeName = NSAttributedString.Key(rawValue: "AgreeViewTouchItemAttributeName")
  private let tapAreaInsets = UIEdgeInsets(top: -2, left: -2, bottom: -2, right: -2)

  @objc public var fullContent = "" {
    didSet {
      guard fullContent.count > 0, let items = selectAgreements, items.count > 0 else {
        return
      }
      calculateContent()
    }
  }
  @objc public var selectAgreements: [String]? {
    didSet {
      guard fullContent.count > 0, let items = selectAgreements, items.count > 0 else {
        return
      }
      calculateContent()
    }
  }
  @objc public var agreementClick: ((Int) -> Void)?

  private var agreements = [Agreement]()

  @objc init(
    font: UIFont = UIFont.al.regularChineseFont(ofSize: 14.al.val),
    foregroundColor: UIColor = UIColor.Theme.black,
    hightlightedColor: UIColor = UIColor.Theme.themeColor
  ) {
    self.font = font
    self.foregroundColor = foregroundColor
    self.hightlightedColor = hightlightedColor
    super.init(frame: .zero)
    _commonInit()
  }

  override init(frame: CGRect) {
    self.font = UIFont.al.regularChineseFont(ofSize: 14.al.val)
    self.foregroundColor = UIColor.Theme.black
    self.hightlightedColor = UIColor.Theme.themeColor
    super.init(frame: frame)
    _commonInit()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override public func sizeThatFits(_ size: CGSize) -> CGSize {
    return textView.sizeThatFits(size)
  }

  override public func layoutSubviews() {
    super.layoutSubviews()

    let h = textView.sizeThatFits(CGSize(width: kScreenW, height: kScreenH)).height
    textView.translatesAutoresizingMaskIntoConstraints = false
    let left = textView.leftAnchor.constraint(equalTo: leftAnchor)
    let right = textView.rightAnchor.constraint(equalTo: rightAnchor)
    let top = textView.topAnchor.constraint(equalTo: topAnchor)
    let height = textView.heightAnchor.constraint(equalToConstant: h)
    NSLayoutConstraint.activate([left, right, top, height])
  }

  private func _commonInit() {
    addSubview(textView)
  }

  private func calculateContent() {
    let attrM = NSMutableAttributedString(string: fullContent)
    attrM.addAttributes([
      NSAttributedString.Key.font : font,
      NSAttributedString.Key.foregroundColor : foregroundColor,
    ], range: NSRange(location: 0, length: attrM.length))

    textView.attributedText = attrM

    guard let items = selectAgreements else { return }

    var index = 0
    for item in items {
      let range = (fullContent as NSString).range(of: item)
      attrM.addAttributes([
        NSAttributedString.Key.foregroundColor : hightlightedColor,
      ], range: range)

      let agreement = Agreement(name: touchItemAttributeName, range: range, index: index)
      agreements.append(agreement)

      index += 1
    }
    textView.attributedText = attrM

    for item in agreements {
      textView.textStorage.addAttribute(item.name, value: item.index, range: item.range)
    }
  }

  // MARK: - Response

  @objc private func _tapAction(_ tap: UITapGestureRecognizer) {
    guard textView.textStorage.string.count > 0 else {
      return
    }

    let point = tap.location(in: textView)

    let range = NSRange(location: 0, length: textView.textStorage.string.count)

    textView.textStorage.enumerateAttribute(touchItemAttributeName, in: range, options: []) { (value, range, stopPtr) in
      guard let value = value as? Int else { return }
      self.enumerateViewRectsForRanges([NSValue(range: range)]) { [unowned self] (rect, _, _) in
        if rect.contains(point) {
          stopPtr.pointee = true
          self.agreementClick.map { $0(value) }
        }
      }
    }
  }

  private func enumerateViewRectsForRanges(_ ranges: [NSValue], complete: @escaping (_ rect: CGRect, _ range: NSRange, _ stop: Bool) -> Void) {
    for rangeValue in ranges {
      let range = rangeValue.rangeValue
      let glyphRange = textView.layoutManager.glyphRange(forCharacterRange: range, actualCharacterRange: nil)
      textView.layoutManager.enumerateEnclosingRects(forGlyphRange: glyphRange, withinSelectedGlyphRange: NSMakeRange(NSNotFound, 0), in: textView.textContainer, using: { (rect, stop) -> Void in
        var rect = rect
        rect.origin.x += self.textView.textContainerInset.left
        rect.origin.y += self.textView.textContainerInset.top
        rect = rect.inset(by: self.tapAreaInsets)
        complete(rect, range, true)
      })
    }

    return
  }

  // MARK: - Lazy

  private lazy var textView: UITextView = {
    let tv = UITextView()
    tv.isEditable = false
    tv.isScrollEnabled = false
    tv.isSelectable = false
    tv.clipsToBounds = false
    tv.backgroundColor = self.backgroundColor
    tv.font = self.font
    tv.textColor = self.foregroundColor
    tv.addGestureRecognizer(self.tapGesture)

    return tv
  }()

  private lazy var tapGesture: UITapGestureRecognizer = {
    UITapGestureRecognizer(target: self, action: #selector(_tapAction(_:)))
  }()

}
