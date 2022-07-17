//
//  FavoriteUseCase.swift
//  testApp
//
//  Created by Ian on 2022/07/17.
//

import RxSwift

protocol FavoriteUseCase {
  func fetchFavoriteItems() -> Observable<[Item]>
}

final class DefaultFavoriteUSeCase: FavoriteUseCase {

  private let persistentStorage: PersistentStorage

  init() {
    self.persistentStorage = PersistentStorage.shared
  }

  func fetchFavoriteItems() -> Observable<[Item]> {
    .just(Array(persistentStorage.fetchFavoriteItemList()))
  }
}
