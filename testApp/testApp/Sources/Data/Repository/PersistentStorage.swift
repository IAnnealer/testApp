//
//  PersistentStorage.swift
//  testApp
//
//  Created by Ian on 2022/07/17.
//

import RealmSwift
import RxSwift

final class PersistentStorage: LocalStorable {

  func fetch() -> Observable<[Item]> {
    let realm = try! Realm()
    return .just(.init(realm.objects(Item.self)))
  }

  func add(item: Item) -> Observable<[Item]> {
    let realm = try! Realm()

    let newItem = Item(id: item.id,
                    name: item.name,
                    imageURLString: item.imageURLString,
                    actualPrice: item.actualPrice,
                    price: item.price,
                    isNew: item.isNew,
                    sellCount: item.sellCount)
    
    try! realm.safeWrite {
      realm.add(newItem)
    }

    return fetch()
  }

  func delete(item: Item) -> Observable<[Item]> {
    let realm = try! Realm()

    let item = realm.objects(Item.self).filter { $0.id == item.id }

    try! realm.safeWrite {
      realm.delete(item)
    }

    return fetch()
  }
}

extension Realm {
    public func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
}
