//
//  FavoritesViewController.swift
//  testApp
//
//  Created by Ian on 2022/07/16.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class FavoritesViewController: BaseViewController {

  private enum Constant {
    static let navigationTitle = "좋아요"
  }

  // MARK: - Properties
  private weak var collectionView: UICollectionView!
  private weak var loadingView: UIView!
  private let viewModel: FavoritesViewModel

  init(viewModel: FavoritesViewModel) {
    self.viewModel = viewModel

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Override
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func setupViews() {
    super.setupViews()
    
    navigationItem.title = Constant.navigationTitle

    let flowLayout: UICollectionViewFlowLayout = .init().then {
      $0.scrollDirection = .vertical
      $0.minimumInteritemSpacing = 0
      $0.minimumLineSpacing = 0
    }

    collectionView = .init(frame: .zero, collectionViewLayout: flowLayout).then {
      $0.registerCellClass(cellType: GoodsCell.self)
      $0.dataSource = self
      $0.delegate = self
      $0.showsHorizontalScrollIndicator = false
      $0.backgroundColor = .clear
      view.addSubview($0)
    }

    loadingView = .init().then {
      $0.backgroundColor = .white
      view.addSubview($0)
    }
  }

  override func setupLayoutConstraints() {
    collectionView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }

    loadingView.snp.makeConstraints {
      $0.edges.equalTo(collectionView)
    }
  }

  override func bind() -> Disposable {
    let input: FavoritesViewModel.Input = .init(requestContents: rx.viewWillAppear)
    let output: FavoritesViewModel.Output = viewModel.transform(input)

    return Disposables.create([
      super.bind(),

      rx.viewWillAppear
        .asDriverSkipError()
        .drive(onNext: { [weak self] in
          self?.bringLoadingViewToFront()
        }),

      output.didReceiveContents
        .asDriverSkipError()
        .drive(onNext: { [weak self] in
          self?.bringCollectionViewToFront()
          self?.collectionView.reloadData()
        })
    ])
  }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return viewModel.favoriteItemList.count
  }

  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    guard let item = viewModel.favoriteItemList[safe: indexPath.item] else {
      return .init(frame: .zero)
    }

    let cell = collectionView.dequeueReusableCell(cellType: GoodsCell.self, indexPath: indexPath)
    cell.configure(item: item, isFavoriteScene: true)

    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    guard let item = viewModel.favoriteItemList[safe: indexPath.item] else { return .zero }
    let defaultHeight: CGFloat = 60
    return .calcuateGoodsCellSize(width: collectionView.frame.width,
                                  defaultHeight: defaultHeight,
                                  item: item)
  }
}

// MARK: - Private
private extension FavoritesViewController {
  func bringCollectionViewToFront() {
    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.loadingView.alpha = 0
    } completion: { [weak self] _ in
      guard let self = self else { return }
      self.collectionView.bringSubviewToFront(self.loadingView)
    }
  }

  func bringLoadingViewToFront() {
    loadingView.alpha = 1
    loadingView.bringSubviewToFront(collectionView)
  }
}
