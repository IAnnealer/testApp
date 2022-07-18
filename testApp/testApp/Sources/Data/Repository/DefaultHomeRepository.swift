//
//  DefaultHomeRepository.swift
//  testApp
//
//  Created by Ian on 2022/07/16.
//

import RxSwift

final class DefaultHomeRepository: HomeRepository {
  func fetchContents() -> Observable<ContentReponse> {
    return APIProvider.request(GoodsAPI.fetchContents)
      .map(ContentReponse.self)
      .asObservable()
  }

  func fetchMoreGoods(lastId: Int) -> Observable<GoodsResponse> {
    return APIProvider.request(GoodsAPI.fetchGoods(lastId: "\(lastId)"))
      .map(GoodsResponse.self)
      .asObservable()
  }
}

