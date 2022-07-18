//
//  GoodsCell.swift
//  testApp
//
//  Created by Ian on 2022/07/16.
//

import UIKit

import RxSwift
import RxRelay
import SDWebImage

final class GoodsCell: UICollectionViewCell {

  static let nameLabelWidth: CGFloat = UIScreen.main.bounds.width -
  (Constant.defaultPadding * 2 + Constant.imagewidth + Constant.imageToNameHorizontalDistance)
  static let nameLabelFont: UIFont = .systemFont(ofSize: 11)

  private enum Constant {
    static let defaultPadding: CGFloat = 10
    static let imagewidth: CGFloat = 60
    static let imageToNameHorizontalDistance: CGFloat = 10
    static let favoriteButtonImageTitle = "heart"
    static let favoriteButtonSelectedImageTitle = "heart.fill"
    static let newTitle = "NEW"
    static let placeholderImageName = "placeholderImage"
  }

  // MARK: - Properties
  private weak var imageContainerView: UIView!
  private weak var imageView: UIImageView!
  private weak var addFavoriteButton: UIButton!
  private weak var nameLabel: UILabel!
  private weak var discountGuideLabel: UILabel!
  private weak var priceLabel: UILabel!
  private weak var isNewLabel: UILabel!
  private weak var sellCountLabel: UILabel!

  private var feedbackGenerator: UIImpactFeedbackGenerator!

  private var isNewItem: Bool = false
  private var isFavoriteRelay: BehaviorRelay<Bool> = .init(value: false)
  private var disposeBag: DisposeBag = .init()

  private var item: Item? {
    didSet {
      isNewItem = item?.isNew ?? false
    }
  }

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

    disposeBag = .init()

    imageView.image = nil
    nameLabel.text = nil
    priceLabel.text = nil
    discountGuideLabel.text = nil
    isNewLabel.isHidden = false
    isNewLabel?.text = nil
    sellCountLabel.isHidden = false
    sellCountLabel.text = nil
    addFavoriteButton.imageView?.image = nil
  }

  func configure(
    item: Item?,
    isFavoriteItem: Bool = false,
    isFavoriteScene: Bool = false,
    addFavoriteTrigger: AnyObserver<Item>? = nil,
    deleteFavoriteTrigger: AnyObserver<Item>? = nil
  ) {
    self.item = item
    self.isFavoriteRelay.accept(isFavoriteItem)

    if !isFavoriteScene {
      addFavoriteButton.rx.controlEvent(.touchUpInside)
        .asDriver()
        .throttle(.milliseconds(500), latest: false)
        .drive(onNext: { [weak self] in
          self?.feedbackGenerator.impactOccurred()

          guard let self = self, let item = self.item else { return }

          let isFavorite = self.isFavoriteRelay.value

          if isFavorite {
            deleteFavoriteTrigger?.onNext(item)
          } else {
            addFavoriteTrigger?.onNext(item)
          }

          self.isFavoriteRelay.accept(!isFavorite)
        })
        .disposed(by: disposeBag)

      isFavoriteRelay
        .asDriver()
        .drive(onNext: changeFavoriteButtonImage(isFavoirte:))
        .disposed(by: disposeBag)
    }

    addFavoriteButton.isHidden = isFavoriteScene
    reloadContents(item: item)
  }
}

// MARK: - Private
private extension GoodsCell {
  func reloadContents(item: Item?) {
    guard let placeholderImage: UIImage = .init(named: Constant.placeholderImageName),
          let item = item else { return }

    discountGuideLabel.text = "\(item.discountRate)%"
    priceLabel.text = decmialWon(value: item.price)
    nameLabel.text = "\(item.name)"
    imageView.sd_setImage(with: item.imageURL, placeholderImage: placeholderImage)

    if item.sellCount >= 10 {
      sellCountLabel.text = "\(item.sellCount)개 구매중"
    } else {
      sellCountLabel.isHidden = true
    }

    if !item.isNew {
      isNewLabel.isHidden = true

      sellCountLabel.snp.updateConstraints {
        $0.leading.equalTo(nameLabel)
      }
    } else {
      isNewLabel.text = Constant.newTitle

      sellCountLabel.snp.updateConstraints {
        $0.leading.equalTo(nameLabel).offset(40)
      }
    }

    changeFavoriteButtonImage(isFavoirte: isFavoriteRelay.value)
  }

  func setupViews() {
    contentView.backgroundColor = .clear

    imageContainerView = .init().then {
      $0.backgroundColor = .clear
      contentView.addSubview($0)
    }

    imageView = .init().then {
      $0.contentMode = .scaleAspectFill
      $0.cornerRadius(radius: 5)
      imageContainerView.addSubview($0)
    }

    addFavoriteButton = .init().then {
      $0.setImage(.init(systemName: Constant.favoriteButtonImageTitle), for: .normal)
      $0.imageView?.tintColor = .white
      imageContainerView.addSubview($0)
    }

    discountGuideLabel = .init().then {
      $0.font = .systemFont(ofSize: 13, weight: .bold)
      $0.textColor = GlobalConstant.Color.accent
      contentView.addSubview($0)
    }

    priceLabel = .init().then {
      $0.font = .systemFont(ofSize: 13, weight: .bold)
      $0.textColor = GlobalConstant.Color.text_primary
      contentView.addSubview($0)
    }

    nameLabel = .init().then {
      $0.numberOfLines = 0
      $0.font = .systemFont(ofSize: 11)
      $0.textColor = GlobalConstant.Color.text_secondary
      contentView.addSubview($0)
    }

    isNewLabel = .init().then {
      $0.text = Constant.newTitle
      $0.textAlignment = .center
      $0.font = .systemFont(ofSize: 8, weight: .bold)
      $0.textColor = .darkGray
      $0.layer.borderColor = UIColor.lightGray.cgColor
      $0.layer.borderWidth = 1
      $0.cornerRadius(radius: 3)
      contentView.addSubview($0)
    }

    sellCountLabel = .init().then {
      $0.font = .systemFont(ofSize: 10)
      $0.textColor = GlobalConstant.Color.text_secondary
      contentView.addSubview($0)
    }

    feedbackGenerator = .init(style: .medium)
  }

  func setupLayoutConstraints() {
    imageContainerView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(Constant.defaultPadding)
      $0.leading.equalToSuperview().offset(Constant.defaultPadding)
      $0.size.equalTo(CGSize(width: Constant.imagewidth, height: Constant.imagewidth))
    }

    imageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    addFavoriteButton.snp.makeConstraints {
      $0.top.equalToSuperview().offset(5)
      $0.trailing.equalToSuperview().offset(-5)
    }

    discountGuideLabel.snp.makeConstraints {
      $0.top.equalTo(imageView).offset(3)
      $0.leading.equalTo(imageContainerView.snp.trailing).offset(Constant.defaultPadding)
      $0.height.equalTo(17)
    }

    priceLabel.snp.makeConstraints {
      $0.centerY.equalTo(discountGuideLabel)
      $0.leading.equalTo(discountGuideLabel.snp.trailing).offset(5)
      $0.trailing.lessThanOrEqualToSuperview().offset(-10)
    }

    nameLabel.snp.makeConstraints {
      $0.top.equalTo(discountGuideLabel.snp.bottom).offset(5)
      $0.leading.equalTo(discountGuideLabel)
      $0.trailing.lessThanOrEqualToSuperview().offset(-10)
    }

    isNewLabel.snp.makeConstraints {
      $0.leading.equalTo(nameLabel)
      $0.size.equalTo(CGSize(width: 35, height: 16))
      $0.bottom.equalToSuperview().offset(-15)
    }

    sellCountLabel.snp.makeConstraints {
      $0.leading.equalTo(nameLabel).offset(40)
      $0.centerY.equalTo(isNewLabel)
    }
  }

  func decmialWon(value: Int) -> String {
    let numberFormatter: NumberFormatter = .init()
    numberFormatter.numberStyle = .decimal
    guard let result = numberFormatter.string(from: NSNumber(value: value)) else {
      return ""
    }

    return result
  }

  func changeFavoriteButtonImage(isFavoirte: Bool) {
    addFavoriteButton.setImage(
      .init(
        systemName: isFavoirte ?
        Constant.favoriteButtonSelectedImageTitle : Constant.favoriteButtonImageTitle
      ),
      for: .normal)

    addFavoriteButton.imageView?.tintColor = isFavoirte ? GlobalConstant.Color.accent : .white
  }
}
