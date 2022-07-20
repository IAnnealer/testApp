//
//  AppCoordinator.swift
//  testApp
//
//  Created by Ian on 2022/07/16.
//

import UIKit

final class AppCoordinator {

  // MARK: - Properties
  var childCoordinators: [Coordinator] = []
  var window: UIWindow

  private var tabBarController: UITabBarController
  @Inject private var homeCoordinator: HomeCoordinator
  @Inject private var favoritesCoordinator: FavoritesCoordinator

  init(in window: UIWindow) {
    self.window = window
    self.tabBarController = .init(nibName: nil, bundle: nil)
  }

  // MARK: - Methods
  func start() {
    setupTabBarCoordinator()
  }
}

// MARK: - Private
private extension AppCoordinator {
  func setupTabBarCoordinator() {
    childCoordinators.append(homeCoordinator)
    childCoordinators.append(favoritesCoordinator)

    let homeNavigationController: UINavigationController = homeCoordinator.startPushHomeScene()
    let favoritesNavigationController: UINavigationController = favoritesCoordinator.startPushFavoritesScene()

    tabBarController.viewControllers = [homeNavigationController, favoritesNavigationController]
    tabBarController.tabBar.tintColor = GlobalConstant.Color.accent
    window.rootViewController = tabBarController
  }
}
