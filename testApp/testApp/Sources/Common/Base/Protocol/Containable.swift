//
//  Containable.swift
//  testApp
//
//  Created by Ian on 2022/07/19.
//

/// `DIConatiner` 에 `register`가 가능한 타입
protocol Injectable {}

protocol Containable {
  /// 의존성 객체를 컨테이너에 등록합니다.
  func register<T: Injectable>(_ dependency: T, keyType: Any)

  /// 컨테이너로부터 의존성 객체를 가져옵니다.
  func resolve<T>(keyType: Any) -> T
}
