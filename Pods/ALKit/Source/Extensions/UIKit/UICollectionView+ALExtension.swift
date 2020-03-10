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
//  UICollectionView+ALExtension.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2019/12/25.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import UIKit

public extension ALWrapper where Base: UICollectionView {

  func numberOfItems() -> Int {
    var section = 0
    var itemsCount = 0
    while section < base.numberOfSections {
      itemsCount += base.numberOfItems(inSection: section)
      section += 1
    }
    return itemsCount
  }

  func indexPathForLastItem(inSection section: Int) -> IndexPath? {
    guard section >= 0 else {
      return nil
    }
    guard section < base.numberOfSections else {
      return nil
    }
    guard base.numberOfItems(inSection: section) > 0 else {
      return IndexPath(item: 0, section: section)
    }
    return IndexPath(item: base.numberOfItems(inSection: section) - 1, section: section)
  }

  func reloadData(_ completion: @escaping () -> Void) {
    UIView.animate(withDuration: 0, animations: {
      self.base.reloadData()
    }, completion: { _ in
      completion()
    })
  }

  func dequeueReusableCell<T: UICollectionViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
    guard let cell = base.dequeueReusableCell(withReuseIdentifier: String(describing: name), for: indexPath) as? T else {
      fatalError("Couldn't find UICollectionViewCell for \(String(describing: name)), make sure the cell is registered with collection view")
    }
    return cell
  }

  func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind kind: String, withClass name: T.Type, for indexPath: IndexPath) -> T {
    guard let cell = base.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: name), for: indexPath) as? T else {
      fatalError("Couldn't find UICollectionReusableView for \(String(describing: name)), make sure the view is registered with collection view")
    }
    return cell
  }

  func register<T: UICollectionReusableView>(supplementaryViewOfKind kind: String, withClass name: T.Type) {
    base.register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: name))
  }

  func register<T: UICollectionViewCell>(nib: UINib?, forCellWithClass name: T.Type) {
    base.register(nib, forCellWithReuseIdentifier: String(describing: name))
  }

  func register<T: UICollectionViewCell>(cellWithClass name: T.Type) {
    base.register(T.self, forCellWithReuseIdentifier: String(describing: name))
  }

  func register<T: UICollectionReusableView>(nib: UINib?, forSupplementaryViewOfKind kind: String, withClass name: T.Type) {
    base.register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: name))
  }

  func register<T: UICollectionViewCell>(nibWithCellClass name: T.Type, at bundleClass: AnyClass? = nil) {
    let identifier = String(describing: name)
    var bundle: Bundle?

    if let bundleName = bundleClass {
      bundle = Bundle(for: bundleName)
    }

    base.register(UINib(nibName: identifier, bundle: bundle), forCellWithReuseIdentifier: identifier)
  }

  func safeScrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
    guard indexPath.item >= 0 &&
      indexPath.section >= 0 &&
      indexPath.section < base.numberOfSections &&
      indexPath.item < base.numberOfItems(inSection: indexPath.section) else {
        return
    }
    base.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
  }

  func isValidIndexPath(_ indexPath: IndexPath) -> Bool {
    return indexPath.section >= 0 &&
      indexPath.item >= 0 &&
      indexPath.section < base.numberOfSections &&
      indexPath.item < base.numberOfItems(inSection: indexPath.section)
  }

}
