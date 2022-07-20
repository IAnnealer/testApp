//
//  DIContainer.swift
//  testApp
//
//  Created by Ian on 2022/07/20.
//

final class DIContainer: Containable {

  // MARK: - Properties
  static let shared: DIContainer = .init()
  private(set) var dependencies: [String: Any] = .init()

  private init() {}

  // MARK: - Methods
  func register<T: Injectable>(_ dependency: T, keyType: Any) {
    let key = String(describing: keyType.self)
    dependencies[key] = dependency
  }

  func resolve<T>(keyType: Any) -> T {
    let key: String = .init(describing: keyType.self)
    let dependency = dependencies[key]

    precondition(dependency != nil, "\(key)를 찾을 수 없습니다.")

    return dependency as! T
  }
}
