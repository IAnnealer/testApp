//
//  SceneDelegate.swift
//  testApp
//
//  Created by Ian on 2022/07/16.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  private var appCoordinator: AppCoordinator?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let window: UIWindow = .init(windowScene: windowScene)
    window.makeKeyAndVisible()
    self.window = window

    appCoordinator = .init(in: window)
    appCoordinator?.start()
  }

  func sceneDidDisconnect(_ scene: UIScene) {
  }

  func sceneDidBecomeActive(_ scene: UIScene) {
  }

  func sceneWillResignActive(_ scene: UIScene) {
  }

  func sceneWillEnterForeground(_ scene: UIScene) {

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
  }
}

