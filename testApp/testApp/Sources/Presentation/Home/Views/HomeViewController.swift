//
//  HomeViewController.swift
//  testApp
//
//  Created by Ian on 2022/07/16.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class HomeViewController: BaseViewController {

  private enum Constant {
    static let navigationTitle = "홈"
  }

  // MARK: - Properties
  private weak var collectionView: UICollectionView!
  private var refreshControl: UIRefreshControl!
  private weak var loadingView: UIView!
  private weak var activityIndicatorView: UIActivityIndicatorView!
  private let viewModel: HomeViewModel!

  private let requestExtraTrigger: PublishSubject<Void> = .init()
  private let addFavoriteItemSubject: PublishSubject<Item> = .init()
  private let deleteFavoriteItemSubject: PublishSubject<Item> = .init()

  init(viewModel: HomeViewModel) {
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

    refreshControl = .init().then {
      $0.tintColor = GlobalConstant.Color.accent
    }

    let flowLayout: UICollectionViewFlowLayout = .init().then {
      $0.scrollDirection = .vertical
      $0.minimumInteritemSpacing = 0
      $0.minimumLineSpacing = 0
    }

    collectionView = .init(frame: .zero, collectionViewLayout: flowLayout).then {
      $0.registerCellClass(cellType: BannerListCell.self)
      $0.registerCellClass(cellType: GoodsCell.self)
      $0.dataSource = self
      $0.delegate = self
      $0.showsHorizontalScrollIndicator = false
      $0.backgroundColor = .clear
      $0.refreshControl = refreshControl
      view.addSubview($0)
    }

    loadingView = .init().then {
      $0.backgroundColor = .white
      view.addSubview($0)
    }

    activityIndicatorView = .init(style: .large).then {
      $0.backgroundColor = .clear
      $0.color = GlobalConstant.Color.accent
      loadingView.addSubview($0)
    }
  }

  override func setupLayoutConstraints() {
    collectionView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }

    activityIndicatorView.snp.makeConstraints {
      $0.center.equalToSuperview()
    }

    loadingView.snp.makeConstraints {
      $0.edges.equalTo(collectionView)
    }
  }

  override func bind() -> Disposable {
    let viewWillAppear = rx.viewWillAppear
      .asDriverSkipError()
      .do(onNext: { [weak self] in
        self?.bringLoadingViewToFront()
      })

    let requestInitialContents = Observable<Void>.merge(
      viewWillAppear.asObservable(),
      refreshControl.rx.controlEvent(.valueChanged).asObservable()
    )

    let input: HomeViewModel.Input = .init(
      requestInitialContents: requestInitialContents.asObservable(),
      requestExtraContents: collectionView.rx_reachedBottom,
      addFavoriteItem: addFavoriteItemSubject.asObservable(),
      deleteFavoriteItem: deleteFavoriteItemSubject.asObservable()
    )
    let output: HomeViewModel.Output = viewModel.transform(input)

    return Disposables.create([
      super.bind(),

      output.didReceiveInitialContents
        .asDriverSkipError()
        .drive(onNext: { [weak self] in
          self?.bringCollectionViewToFront()
          self?.collectionView.reloadData()
          self?.refreshControl.endRefreshing()
        }),

      output.didReceiveExtraContents
        .asDriverSkipError()
        .drive(onNext: { [weak self] in
          self?.collectionView.reloadData()
        }),

      output.didChangeFavoriteItemStatus
        .subscribe()
    ])
  }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  typealias HomeSection = HomeViewModel.Section

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    HomeSection.allCases.count
  }

  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    guard let section = HomeSection(rawValue: section) else { return .zero }

    switch section {
    case .banner:
      return 1
    case .goods:
      return viewModel.contentsResponse?.goods.count ?? 0
    }
  }

  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let section = HomeSection(rawValue: indexPath.section) else { return .init(frame: .zero) }

    let cell: UICollectionViewCell
    switch section {
    case .banner:
      let bannerListCell = collectionView.dequeueReusableCell(cellType: BannerListCell.self,
                                                              indexPath: indexPath)
      bannerListCell.configure(banners: viewModel.contentsResponse?.banners)
      cell = bannerListCell
    case .goods:
      guard let item = viewModel.contentsResponse?.goods[safe: indexPath.item] else {
        return .init(frame: .zero)
      }

      let isFavorite: Bool = viewModel.favoriteItemIdList?.contains(item.id) ?? false
      let goodsCell = collectionView.dequeueReusableCell(cellType: GoodsCell.self,
                                                         indexPath: indexPath)
      goodsCell.configure(
        item: item,
        isFavoriteItem: isFavorite,
        addFavoriteTrigger: addFavoriteItemSubject.asObserver(),
        deleteFavoriteTrigger: deleteFavoriteItemSubject.asObserver()
      )
      cell = goodsCell
    }

    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    guard let section = HomeSection(rawValue: indexPath.section) else { return .zero }

    let width: CGFloat = collectionView.frame.width
    switch section {
    case .banner:
      return .init(width: width, height: view.frame.height * 0.23)
    case .goods:
      guard let item = viewModel.contentsResponse?.goods[safe: indexPath.item] else { return .zero }
      let defaultHeight: CGFloat = 60
      return .calcuateGoodsCellSize(width: width, defaultHeight: defaultHeight, item: item)
    }
  }
}

// MARK: - Private
private extension HomeViewController {
  func bringCollectionViewToFront() {
    activityIndicatorView.stopAnimating()

    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.loadingView.alpha = 0
    } completion: { [weak self] _ in
      guard let self = self else { return }
      self.collectionView.bringSubviewToFront(self.loadingView)
    }
  }

  func bringLoadingViewToFront() {
    loadingView.alpha = 1
    loadingView.bringSubviewToFront(self.collectionView)
    activityIndicatorView.startAnimating()
  }
}
