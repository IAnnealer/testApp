//
//  BannerCell.swift
//  testApp
//
//  Created by Ian on 2022/07/16.
//

import UIKit

final class BannerCell: UICollectionViewCell {

  // MARK: - Properties
  private weak var containerView: UIView!
  private weak var collectionView: UICollectionView!
  private weak var countLabel: UILabel!

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension BannerCell {
  func setupViews() {

  }

  func setupLayoutConstraints() {
    
  }
}
