//
//  HomeUseCase.swift
//  testApp
//
//  Created by Ian on 2022/07/16.
//

import RxSwift

protocol HomeUseCase {
  func fetchContents() -> Observable<ContentReponse>
  func fetchMoreGoods(lastId: Int) -> Observable<GoodsResponse>
  func fetchFavoriteItem() -> Observable<[Item]>
  func addFavoriteItem(item: Item)
  func deleteFavoriteItem(item: Item)
}

final class DefaultHomeUseCase: HomeUseCase {

  private let homeRepository: HomeRepository
  private let persistentStorage: LocalStorable

  init() {
    self.homeRepository = DefaultHomeRepository()
    self.persistentStorage = PersistentStorage.shared
  }

  func fetchContents() -> Observable<ContentReponse> {
    homeRepository.fetchContents()
  }

  func fetchMoreGoods(lastId: Int) -> Observable<GoodsResponse> {
    homeRepository.fetchMoreGoods(lastId: lastId)
  }

  func fetchFavoriteItem() -> Observable<[Item]> {
    persistentStorage.fetch()
  }

  func addFavoriteItem(item: Item) {
    persistentStorage.add(item: item)
  }

  func deleteFavoriteItem(item: Item) {
    persistentStorage.delete(item: item)
  }
}
