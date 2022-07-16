//
//  FavoritesCoordinator.swift
//  testApp
//
//  Created by Ian on 2022/07/16.
//

import UIKit

import Then

protocol FavoritesCoordinator: Coordinator {
  func startPushFavoritesScene() -> UINavigationController
}

final class DefaultFavoritesCoordinator: FavoritesCoordinator {

  private enum Constant {
    static let tabBarTitle = "좋아요"
    static let tabBarImageName = "heart"
  }

  // MARK: - Properties
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController

  init() {
    self.navigationController = .init(nibName: nil, bundle: nil)
  }

  func start() {
    let viewController: FavoritesViewController = getViewController()
    navigationController.pushViewController(viewController, animated: true)
  }

  func startPushFavoritesScene() -> UINavigationController {
    return .init(rootViewController: getViewController()).then {
      $0.tabBarItem = .init(title: Constant.tabBarTitle,
                            image: .init(systemName: Constant.tabBarImageName),
                            selectedImage: nil)
    }
  }
}

private extension DefaultFavoritesCoordinator {
  func getViewController() -> FavoritesViewController {
    let viewModel: FavoritesViewModel = .init()
    let viewController: FavoritesViewController = .init(viewModel: viewModel)

    return viewController
  }
}
