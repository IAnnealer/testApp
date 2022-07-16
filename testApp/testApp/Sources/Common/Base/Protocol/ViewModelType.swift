//
//  ViewModelType.swift
//  testApp
//
//  Created by Ian on 2022/07/16.
//

import Foundation

/// 모든 `ViewModel`이 공통적으로 채택하는 프로토콜
protocol ViewModelType {

  // MARK: - Properties
  associatedtype Input
  associatedtype Output

  func transform(_ input: Input) -> Output
}
