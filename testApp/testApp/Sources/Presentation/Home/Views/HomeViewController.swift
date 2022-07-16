//
//  HomeViewController.swift
//  testApp
//
//  Created by Ian on 2022/07/16.
//

import UIKit
import RxSwift

final class HomeViewController: BaseViewController {

  private enum Constant {
    static let navigationTitle = "홈"
  }

  // MARK: - Properties
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
  }

  override func setupLayoutConstraints() {

  }

  override func bind() -> Disposable {
    return Disposables.create([
      super.bind()
    ])
  }
}

