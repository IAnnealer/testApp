//
//  LocalStorable.swift
//  testApp
//
//  Created by Ian on 2022/07/17.
//

import RxSwift

protocol LocalStorable {
  /// 찜 목록에 상품을 추가합니다.
  /// - Parameter item: 추가 대상 상품.
  /// - Returns: 해당 상품이 추가된 찜 목록 리스트.
  func add(item: Item) -> Observable<[Item]>

  /// 찜 목록 리스트를 반환합니다.
  /// - Returns: 찜 목록 리스트
  func fetch() -> Observable<[Item]>

  /// 찜 목록에서 상품을 제거합니다.
  /// - Parameter item: 제거 대상 상품.
  /// - Returns: 해당 상품이 제거된 찜 목록 리스트.
  func delete(item: Item) -> Observable<[Item]>
}
