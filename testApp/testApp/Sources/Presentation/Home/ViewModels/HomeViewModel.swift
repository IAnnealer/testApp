//
//  HomeViewModel.swift
//  testApp
//
//  Created by Ian on 2022/07/16.
//

import RxSwift

final class HomeViewModel {
  enum Section: Int, CaseIterable {
    case banner
    case goods
  }

  // MARK: - Properties
  private(set) var contentsResponse: ContentReponse?
  private var favoriteItemList: [Item]? {
    didSet {
      favoriteItemIdList = favoriteItemList?.map { $0.id }
    }
  }

  private(set) var favoriteItemIdList: [Int]?
  private(set) var hasMoreContents: Bool = true
  private let useCase: HomeUseCase

  init(useCase: HomeUseCase) {
    self.useCase = useCase
  }
}

extension HomeViewModel: ViewModelType {
  struct Input {
    let requestInitialContents: Observable<Void>
    let requestExtraContents: Observable<Void>
    let addFavoriteItem: Observable<Item>
    let deleteFavoriteItem: Observable<Item>
  }

  struct Output {
    let didReceiveInitialContents: Observable<Void>
    let didReceiveExtraContents: Observable<Void>
    let didChangeFavoriteItemStatus: Observable<Void>
  }

  func transform(_ input: Input) -> Output {
    let didReceiveInitialContents = input.requestInitialContents
      .flatMapLatest(fetchInitialContents)

    let didReceiveExtraContents = input.requestExtraContents.throttle(
      .seconds(1),
      scheduler: MainScheduler.instance
    )
      .flatMapLatest(fetchExtraContents)

    let didAddFavoriteItem = input.addFavoriteItem
      .flatMapLatest(addFavorItem(item:))

    let didDeleteFavoriteItem = input.deleteFavoriteItem
      .flatMapLatest(deleteFavoriteItem(item:))

    return .init(
      didReceiveInitialContents: didReceiveInitialContents,
      didReceiveExtraContents: didReceiveExtraContents,
      didChangeFavoriteItemStatus: .merge(didAddFavoriteItem, didDeleteFavoriteItem)
    )
  }
}

// MARK: - Private
private extension HomeViewModel {
  func fetchInitialContents() -> Observable<Void> {
    return .combineLatest(useCase.fetchContents(), useCase.fetchFavoriteItem()) { [weak self] in
      self?.contentsResponse = $0
      self?.favoriteItemList = $1
      self?.hasMoreContents = true
    }
    .map { _ in }
  }

  func fetchExtraContents() -> Observable<Void> {
    guard let lastId = contentsResponse?.goods.last?.id, hasMoreContents else { return .empty() }

    return useCase.fetchMoreGoods(lastId: lastId)
      .filter { [weak self] goodsResponse in
        if goodsResponse.goods.isEmpty {
          self?.hasMoreContents = false
          return false
        } else {
          return true
        }
      }
      .do(onNext: { [weak self] in
        self?.contentsResponse?.goods.append(contentsOf: $0.goods)
      })
      .map { _ in }
  }

  func addFavorItem(item: Item) -> Observable<Void> {
    useCase.addFavoriteItem(item: item)
      .do(onNext: { [weak self] in
        self?.favoriteItemList = $0
      })
      .map { _ in }
  }

  func deleteFavoriteItem(item: Item) -> Observable<Void> {
    useCase.deleteFavoriteItem(item: item)
      .do(onNext: { [weak self] in
        self?.favoriteItemList = $0
      })
      .map { _ in }
  }
}
