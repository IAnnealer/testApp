//
//  BannerListCell.swift
//  testApp
//
//  Created by Ian on 2022/07/16.
//

import UIKit

import SnapKit
import Then

final class BannerListCell: UICollectionViewCell {

  // MARK: - Properties
  private weak var containerView: UIView!
  private weak var collectionView: UICollectionView!
  private weak var countLabel: UILabel!

  private var banners: [Banner]?

  override init(frame: CGRect) {
    super.init(frame: frame)

    setupViews()
    setupLayoutConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(banners: [Banner]?) {
    guard let banners = banners else { return }
    self.banners = banners
    self.countLabel.text = "1 / \(banners.count)"

    reloadContents()
  }
}

// MARK: - Private
private extension BannerListCell {
  func setupViews() {
    containerView = .init().then {
      contentView.addSubview($0)
    }

    let flowLayout: UICollectionViewFlowLayout = .init().then {
      $0.scrollDirection = .horizontal
      $0.minimumInteritemSpacing = 0
      $0.minimumLineSpacing = 0
    }

    collectionView = .init(frame: .zero, collectionViewLayout: flowLayout).then {
      $0.backgroundColor = .clear
      $0.isPagingEnabled = true
      $0.registerCellClass(cellType: BannerCell.self)
      $0.showsHorizontalScrollIndicator = false
      $0.delegate = self
      $0.dataSource = self
      containerView.addSubview($0)
    }

    countLabel = .init().then {
      $0.textAlignment = .center
      $0.textColor = .white
      $0.backgroundColor = .darkGray.withAlphaComponent(0.8)
      $0.font = .systemFont(ofSize: 11)
      $0.cornerRadius(radius: 15)
      containerView.addSubview($0)
    }
  }

  func setupLayoutConstraints() {
    containerView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    countLabel.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-20)
      $0.bottom.equalToSuperview().offset(-20)
      $0.size.equalTo(CGSize(width: 45, height: 30))
    }
  }

  func reloadContents() {
    collectionView.reloadData()
    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
      self?.collectionView.scrollToItem(
        at: .init(item: 0, section: 0),
        at: .centeredHorizontally,
        animated: true
      )
      self?.countLabel.text = "1 / \(self?.banners?.count ?? 0)"
    })
  }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension BannerListCell: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return banners?.count ?? 0
  }

  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let banner = banners?[safe: indexPath.item] else { return .init(frame: .zero) }

    let cell = collectionView.dequeueReusableCell(cellType: BannerCell.self, indexPath: indexPath)
    cell.configure(banner: banner)

    return cell
  }

  func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                 withVelocity velocity: CGPoint,
                                 targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    let pageIndex: Int = .init(targetContentOffset.pointee.x / collectionView.frame.width) + 1

    DispatchQueue.main.async { [weak self] in
      self?.countLabel.text = "\(pageIndex) / \(self?.banners?.count ?? 0)"
    }
  }
}

extension BannerListCell: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: collectionView.frame.width,
                 height: collectionView.frame.height)
  }
}
