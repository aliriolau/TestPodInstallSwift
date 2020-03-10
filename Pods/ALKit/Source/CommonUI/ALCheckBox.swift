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
//  ALCheckBox.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2019/12/5.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import UIKit

public class ALCheckBox: CheckBox {

  @objc public enum CheckBoxStyle: Int {
    /// ■
    case square = 0
    /// ●
    case circle
    /// x
    case cross
    /// ✓
    case tick
  }

  @objc public enum CheckBoxBorderStyle: Int {
    /// ■
    case square = 0
    /// ▢
    case roundedSquare
    /// ◯
    case rounded
  }

  @objc var checkBoxStyle = CheckBoxStyle.tick {
    didSet {
      switch checkBoxStyle {
      case .square:
        super.style = .square
      case .circle:
        super.style = .circle
      case .cross:
        super.style = .cross
      case .tick:
        super.style = .tick
      default:
        super.style = .tick
      }
    }
  }

  @objc var checkBoxBorderStyle = CheckBoxBorderStyle.rounded {
    didSet {
      switch checkBoxBorderStyle {
      case .square:
        super.borderStyle = .square
      case .roundedSquare:
        super.borderStyle = .roundedSquare(radius: 8)
      case .rounded:
        super.borderStyle = .rounded
      default:
        super.borderStyle = .rounded
      }
    }
  }

  @objc override var isChecked: Bool {
    set { super.isChecked = newValue }
    get { super.isChecked }
  }

  @objc override var uncheckedBackgroundColor: UIColor {
    set { super.uncheckedBackgroundColor = newValue }
    get { super.uncheckedBackgroundColor }
  }

  @objc override var checkedBackgroundColor: UIColor {
    set { super.checkedBackgroundColor = newValue }
    get { super.checkedBackgroundColor }
  }

  @objc override var uncheckedBorderColor: UIColor {
    set { super.uncheckedBorderColor = newValue }
    get { super.uncheckedBorderColor }
  }

  @objc override var checkedBorderColor: UIColor {
    set { super.checkedBorderColor = newValue }
    get { super.checkedBorderColor }
  }

  @objc override var checkmarkColor: UIColor {
    set { super.checkmarkColor = newValue }
    get { super.checkmarkColor }
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)
    super.style = .tick
    super.borderStyle = .rounded
    super.checkmarkColor = .white
    super.checkedBorderColor = UIColor.Theme.red
    super.uncheckedBorderColor = UIColor.Theme.border
    super.checkedBackgroundColor = UIColor.Theme.red
    super.uncheckedBackgroundColor = UIColor.clear
    super.borderWidth = 1.0
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}
