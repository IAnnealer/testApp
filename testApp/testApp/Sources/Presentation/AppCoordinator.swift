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

  // MARK: - Initialize
  init(in window: UIWindow) {
    self.window = window
    self.tabBarController = .init(nibName: nil, bundle: nil)
  }

  func start() {
    setupTabBarCoordinator()
  }
}

// MARK: - Private
private extension AppCoordinator {
  func setupTabBarCoordinator() {
    let homeNavigationController: UINavigationController
    let favoritesNavigationController: UINavigationController

    let homeCoordinator: HomeCoordinator = DefaultHomeCoordinator()
    childCoordinators.append(homeCoordinator)
    homeNavigationController = homeCoordinator.startPushHomeScene()

    let favoritesCoordinator: FavoritesCoordinator = DefaultFavoritesCoordinator()
    childCoordinators.append(favoritesCoordinator)
    favoritesNavigationController = favoritesCoordinator.startPushFavoritesScene()


    tabBarController.viewControllers = [homeNavigationController, favoritesNavigationController]
    tabBarController.tabBar.tintColor = GlobalConstant.Color.accent
    window.rootViewController = tabBarController
  }
}
