//
//  InjectWrapper.swift
//  testApp
//
//  Created by Ian on 2022/07/20.
//

import Foundation

@propertyWrapper
struct Inject<T> {
  let wrappedValue: T

  init() {
    self.wrappedValue = DIContainer.shared.resolve(keyType: T.self)
  }
}
