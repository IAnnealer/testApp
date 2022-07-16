//
//  UIViewController+.swift
//  testApp
//
//  Created by Ian on 2022/07/16.
//

import UIKit

import RxSwift

public extension Reactive where Base: UIViewController {
  var viewDidLoad: Observable<Void> {
      return self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
  }

  var viewWillAppear: Observable<Void> {
      return self.methodInvoked(#selector(Base.viewWillAppear(_:))).map { _ in }
  }
}
