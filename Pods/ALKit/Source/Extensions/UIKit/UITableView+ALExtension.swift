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
//  UITableView+ALExtension.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2019/12/3.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import UIKit

public extension ALWrapper where Base: UITableView {

  func numberOfRows() -> Int {
    var section = 0
    var rowCount = 0
    while section < base.numberOfSections {
      rowCount += base.numberOfRows(inSection: section)
      section += 1
    }
    return rowCount
  }

  func indexPathForLastRow(inSection section: Int) -> IndexPath? {
    guard base.numberOfSections > 0, section >= 0 else { return nil }
    guard base.numberOfRows(inSection: section) > 0 else {
      return IndexPath(row: 0, section: section)
    }
    return IndexPath(row: base.numberOfRows(inSection: section) - 1, section: section)
  }

  func reloadData(_ completion: @escaping () -> Void) {
    UIView.animate(withDuration: 0, animations: {
      self.base.reloadData()
    }, completion: { _ in
      completion()
    })
  }

  func scrollToBottom(animated: Bool = true) {
    let bottomOffset = CGPoint(x: 0, y: base.contentSize.height - base.bounds.size.height)
    base.setContentOffset(bottomOffset, animated: animated)
  }

  func scrollToTop(animated: Bool = true) {
    base.setContentOffset(CGPoint.zero, animated: animated)
  }

  func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type) -> T {
    guard let cell = base.dequeueReusableCell(withIdentifier: String(describing: name)) as? T else {
      fatalError("Couldn't find UITableViewCell for \(String(describing: name)), make sure the cell is registered with table view")
    }
    return cell
  }

  func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
    guard let cell = base.dequeueReusableCell(withIdentifier: String(describing: name), for: indexPath) as? T else {
      fatalError("Couldn't find UITableViewCell for \(String(describing: name)), make sure the cell is registered with table view")
    }
    return cell
  }

  func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(withClass name: T.Type) -> T {
    guard let headerFooterView = base.dequeueReusableHeaderFooterView(withIdentifier: String(describing: name)) as? T else {
      fatalError("Couldn't find UITableViewHeaderFooterView for \(String(describing: name)), make sure the view is registered with table view")
    }
    return headerFooterView
  }

  func register<T: UITableViewHeaderFooterView>(nib: UINib?, withHeaderFooterViewClass name: T.Type) {
    base.register(nib, forHeaderFooterViewReuseIdentifier: String(describing: name))
  }

  func register<T: UITableViewHeaderFooterView>(headerFooterViewClassWith name: T.Type) {
    base.register(T.self, forHeaderFooterViewReuseIdentifier: String(describing: name))
  }

  func register<T: UITableViewCell>(cellWithClass name: T.Type) {
    base.register(T.self, forCellReuseIdentifier: String(describing: name))
  }

  func register<T: UITableViewCell>(nib: UINib?, withCellClass name: T.Type) {
    base.register(nib, forCellReuseIdentifier: String(describing: name))
  }

  func register<T: UITableViewCell>(nibWithCellClass name: T.Type, at bundleClass: AnyClass? = nil) {
    let identifier = String(describing: name)
    var bundle: Bundle?

    if let bundleName = bundleClass {
      bundle = Bundle(for: bundleName)
    }

    base.register(UINib(nibName: identifier, bundle: bundle), forCellReuseIdentifier: identifier)
  }

  func isValidIndexPath(_ indexPath: IndexPath) -> Bool {
    return indexPath.section >= 0 &&
      indexPath.row >= 0 &&
      indexPath.section < base.numberOfSections &&
      indexPath.row < base.numberOfRows(inSection: indexPath.section)
  }

  func safeScrollToRow(at indexPath: IndexPath, at scrollPosition: UITableView.ScrollPosition, animated: Bool) {
    guard indexPath.section < base.numberOfSections else { return }
    guard indexPath.row < base.numberOfRows(inSection: indexPath.section) else { return }
    base.scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
  }

}
