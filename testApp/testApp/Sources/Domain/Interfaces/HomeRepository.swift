//
//  HomeRepository.swift
//  testApp
//
//  Created by Ian on 2022/07/16.
//

import RxSwift

protocol HomeRepository {
  /// 컨텐츠를 요청합니다.
  /// - Returns: `[Banner], [Item]`
  func fetchContents() -> Observable<ContentReponse>

  /// 추가 상품 데이터를 요청합니다.
  /// 응답이 빈 배열인 경우 더 이상 상품이 없음을 의미합니다.
  /// - Parameter lastId: 마지막으로 보여지는 상품의 id.
  /// - Returns: `[Item]`
  func fetchMoreGoods(lastId: Int) -> Observable<GoodsResponse>
}
