//
//  FavoriteUseCase.swift
//  testApp
//
//  Created by Ian on 2022/07/17.
//

import RxSwift

protocol FavoriteUseCase {
  /// 찜 목록 리스트를 반환합니다.
  /// - Returns: 찜 목록 리스트
  func fetchFavoriteItems() -> Observable<[Item]>
}

final class DefaultFavoriteUSeCase: FavoriteUseCase {
  private let persistentStorage: LocalStorable

  init() {
    self.persistentStorage = PersistentStorage()
  }

  func fetchFavoriteItems() -> Observable<[Item]> {
    persistentStorage.fetch()
  }
}
