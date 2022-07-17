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
}

final class DefaultHomeUseCase: HomeUseCase {

  private let repository: HomeRepository

  init() {
    self.repository = DefaultHomeRepository()
  }

  func fetchContents() -> Observable<ContentReponse> {
    repository.fetchContents()
  }

  func fetchMoreGoods(lastId: Int) -> Observable<GoodsResponse> {
    repository.fetchMoreGoods(lastId: lastId)
  }
}
