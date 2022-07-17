//
//  HomeUseCase.swift
//  testApp
//
//  Created by Ian on 2022/07/16.
//

import RxSwift

protocol HomeUseCase {
  /// 컨텐츠를 요청합니다.
  /// - Returns: `[Banner], [Item]`
  func fetchContents() -> Observable<ContentReponse>

  /// 추가 상품 데이터를 요청합니다.
  /// 응답이 빈 배열인 경우 더 이상 상품이 없음을 의미합니다.
  /// - Parameter lastId: 마지막으로 보여지는 상품의 id.
  /// - Returns: `[Item]'
  func fetchMoreGoods(lastId: Int) -> Observable<GoodsResponse>

  /// 찜 목록 리스트를 반환합니다.
  /// - Returns: 찜 목록 리스트.
  func fetchFavoriteItem() -> Observable<[Item]>


  /// 찜 목록에 상품을 추가합니다.
  /// - Parameter item: 추가 대상 상품.
  /// - Returns: 해당 상품이 추가된 찜 목록 리스트.
  func addFavoriteItem(item: Item) -> Observable<[Item]>

  /// 찜 목록에서 상품을 제거합니다.
  /// - Parameter item: 제거 대상 상품.
  /// - Returns: 해당 상품이 제거된 찜 목록 리스트.
  func deleteFavoriteItem(item: Item) -> Observable<[Item]>
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

  func addFavoriteItem(item: Item) -> Observable<[Item]> {
    persistentStorage.add(item: item)
  }

  func deleteFavoriteItem(item: Item) -> Observable<[Item]> {
    persistentStorage.delete(item: item)
  }
}
