//
//  BannerCell.swift
//  testApp
//
//  Created by Ian on 2022/07/16.
//

import UIKit

import SDWebImage
import SnapKit
import Then

final class BannerCell: UICollectionViewCell {

  // MARK: - Properties
  private weak var imageView: UIImageView!

  override init(frame: CGRect) {
    super.init(frame: frame)

    setupViews()
    setupLayoutConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    imageView.image = nil
  }

  func configure(banner: Banner) {
    imageView.sd_setImage(with: banner.imageURL)
  }
}

// MARK: - Private
private extension BannerCell {
  func setupViews() {
    imageView = .init().then {
      $0.contentMode = .scaleAspectFill
      contentView.addSubview($0)
    }
  }

  func setupLayoutConstraints() {
    imageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
