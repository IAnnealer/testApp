//
//  PersistentStorage.swift
//  testApp
//
//  Created by Ian on 2022/07/17.
//

import RealmSwift
import RxSwift

final class PersistentStorage: LocalStorable {

  static let shared: PersistentStorage = .init()

  let realm: Realm

  private init() {
    self.realm = try! Realm()
  }

  func fetch() -> Observable<[Item]> {
    return .just(.init(realm.objects(Item.self)))
  }

  func add(item: Item) -> Observable<[Item]> {
    try! realm.write({
      realm.add(item)
    })

    return fetch()
  }

  func delete(item: Item) -> Observable<[Item]> {
    try! realm.write({
      realm.delete(realm.objects(Item.self).filter { $0.id == item.id })
    })

    return fetch()
  }
}
