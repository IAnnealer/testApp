//
//  FavoriteUseCase.swift
//  testApp
//
//  Created by Ian on 2022/07/17.
//

import RxSwift

protocol FavoriteUseCase: Injectable {
  /// 찜 목록 리스트를 반환합니다.
  /// - Returns: 찜 목록 리스트
  func fetchFavoriteItems() -> Observable<[Item]>
}

final class DefaultFavoriteUSeCase: FavoriteUseCase {

  // MARK: - Properties
  @Inject private var persistentStorage: LocalStorable

  // MARK: - Methods
  func fetchFavoriteItems() -> Observable<[Item]> {
    persistentStorage.fetch()
  }
}
