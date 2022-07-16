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
  private let viewModel: HomeViewModel!

  init(viewModel: HomeViewModel) {
    self.viewModel = viewModel

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func setupViews() {
    super.setupViews()
    
    navigationItem.title = Constant.navigationTitle

    let flowLayout: UICollectionViewFlowLayout = .init().then {
      $0.scrollDirection = .vertical
    }

    collectionView = .init(frame: .zero, collectionViewLayout: flowLayout).then {
      $0.registerCellClass(cellType: BannerCell.self)
      $0.registerCellClass(cellType: GoodsCell.self)
      $0.rx.setDelegate(self).disposed(by: disposeBag)
      $0.backgroundColor = .clear
      view.addSubview($0)
    }
  }

  override func setupLayoutConstraints() {
    collectionView.snp.makeConstraints {
      $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
    }
  }

  override func bind() -> Disposable {
    return Disposables.create([
      super.bind()
    ])
  }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate { }
