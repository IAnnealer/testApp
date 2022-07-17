//
//  HomeRepository.swift
//  testApp
//
//  Created by Ian on 2022/07/16.
//

import RxSwift

protocol HomeRepository {
  func fetchContents() -> Observable<ContentReponse>
  func fetchMoreGoods(lastId: Int) -> Observable<GoodsResponse>
}
