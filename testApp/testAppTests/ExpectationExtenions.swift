//
//  ExpectationExtenions.swift
//  testAppTests
//
//  Created by Ian on 2022/07/20.
//

import Foundation
import RxSwift
import RxNimble
import Nimble
import RxTest

public extension Expectation where T: ObservableConvertibleType {

  internal func transform<U>(_ closure: @escaping (T?) throws -> U?) -> Expectation<U> {
    let exp = expression.cast(closure)
    return Expectation<U>(expression: exp)
  }

  func events(scheduler: TestScheduler,
              disposeBag: DisposeBag,
              startAt initialTime: Int = 0) -> Expectation<[Recorded<Event<T.Element>>]> {
    return transform { source in
      let results = scheduler.createObserver(T.Element.self)

      scheduler.scheduleAt(initialTime) {
        source?.asObservable().subscribe(results).disposed(by: disposeBag)
      }
      scheduler.start()

      return results.events
    }
  }
}
