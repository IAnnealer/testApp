//
//  GoodsCell.swift
//  testApp
//
//  Created by Ian on 2022/07/16.
//

import UIKit

final class GoodsCell: UICollectionViewCell {

  // MARK: - Properties
  private weak var imageView: UIImageView!
  private weak var addFavoriteButton: UIButton!
  private weak var nameLabel: UILabel!
  private weak var discountGuideLabel: UILabel!
  private weak var priceLabel: UILabel!
  private weak var isNewLabel: UILabel!
  private weak var sellCountLabel: UILabel!

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension GoodsCell {
  func setupViews() {

  }

  func setupLayoutConstraints() {

  }
}
