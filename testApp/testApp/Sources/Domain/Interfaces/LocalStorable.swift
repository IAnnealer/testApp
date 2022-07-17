//
//  LocalStorable.swift
//  testApp
//
//  Created by Ian on 2022/07/17.
//

import RxSwift

protocol LocalStorable {
  func add(item: Item)
  func fetch() -> Observable<[Item]>
  func delete(item: Item)
}
