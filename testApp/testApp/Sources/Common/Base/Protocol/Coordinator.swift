//
//  Coordinator.swift
//  testApp
//
//  Created by Ian on 2022/07/16.
//

import UIKit

/// 모든 `Coordinator`가 공통적으로 채택하는 프로토콜
protocol Coordinator: AnyObject, Injectable {

  // MARK: - Properties
  var childCoordinators: [Coordinator] { get set }
  var navigationController: UINavigationController { get set }

  // MARK: - Methods
  func start()
}
