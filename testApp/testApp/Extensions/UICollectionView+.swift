//
//  UICollectionView+.swift
//  testApp
//
//  Created by Ian on 2022/07/16.
//

import UIKit

public extension UICollectionView {
  func registerCellClass(cellType: UICollectionViewCell.Type) {
      let identifer: String = "\(cellType)"
      register(cellType, forCellWithReuseIdentifier: identifer)
  }

  func dequeueReusableCell<T: UICollectionViewCell>(cellType: T.Type = T.self,
                                                    indexPath: IndexPath) -> T {
      return dequeueReusableCell(withReuseIdentifier: "\(cellType)", for: indexPath) as! T
  }
}
