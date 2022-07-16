//
//  BaseViewController.swift
//  testApp
//
//  Created by Ian on 2022/07/16.
//

import UIKit

import RxCocoa
import RxSwift

/// 모든 `ViewController` 가 공통적으로 상속받는 클래스
class BaseViewController: UIViewController {

  var disposeBag: DisposeBag = .init()

  override func viewDidLoad() {
    super.viewDidLoad()

    setupViews()
    setupLayoutConstraints()
    bind()
      .disposed(by: disposeBag)
  }

  /// Override Layout
  func setupViews() { }

  /// Override Constraints
  func setupLayoutConstraints() { }

  func bind() -> Disposable {
    return Disposables.create()
  }

  deinit {
    disposeBag = .init()
  }
}
