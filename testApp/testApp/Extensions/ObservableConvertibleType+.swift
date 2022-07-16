//
//  ObservableConvertibleType+.swift
//  testApp
//
//  Created by Ian on 2022/07/16.
//

import RxCocoa
import RxSwift

extension ObservableConvertibleType {
  func asDriverSkipError() -> Driver<Element> {
    asDriver(onErrorDriveWith: .empty())
  }
}
