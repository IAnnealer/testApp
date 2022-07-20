//
//  HomeCoordinator.swift
//  testApp
//
//  Created by Ian on 2022/07/16.
//

import UIKit

import Then

protocol HomeCoordinator: Coordinator {
  func startPushHomeScene() -> UINavigationController
}

final class DefaultHomeCoordinator: HomeCoordinator {

  private enum Constant {
    static let tabBarTitle = "홈"
    static let tabBarImageName = "house.fill"
  }

  // MARK: - Properties
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController
  @Inject private var useCase: HomeUseCase

  init() {
    self.navigationController = .init(nibName: nil, bundle: nil)

    UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.black]
  }

  // MARK: - Methods
  func start() {
    let viewController: HomeViewController = getViewController()
    navigationController.pushViewController(viewController, animated: true)
  }

  func startPushHomeScene() -> UINavigationController {
    return .init(rootViewController: getViewController()).then {
      $0.tabBarItem = .init(title: Constant.tabBarTitle,
                            image: .init(systemName: Constant.tabBarImageName),
                            selectedImage: nil)
    }
  }
}

// MARK: - Private
private extension DefaultHomeCoordinator {
  func getViewController() -> HomeViewController {
    let viewModel: HomeViewModel = .init(useCase: useCase)
    let viewController: HomeViewController = .init(viewModel: viewModel)

    return viewController
  }
}
