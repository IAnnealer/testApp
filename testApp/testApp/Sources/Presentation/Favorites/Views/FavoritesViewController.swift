//
//  FavoritesViewController.swift
//  testApp
//
//  Created by Ian on 2022/07/16.
//

import Foundation

import RxCocoa
import RxSwift
import SnapKit
import Then

final class FavoritesViewController: BaseViewController {

  private enum Constant {
    static let navigationTitle = "좋아요"
  }

  // MARK: - Properties
  private let viewModel: FavoritesViewModel

  init(viewModel: FavoritesViewModel) {
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
  }

  override func setupLayoutConstraints() {

  }

  override func bind() -> Disposable {
    return Disposables.create([
      super.bind()
    ])
  }
}
