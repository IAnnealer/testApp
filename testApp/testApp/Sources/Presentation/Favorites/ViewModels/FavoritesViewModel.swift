//
//  FavoritesViewModel.swift
//  testApp
//
//  Created by Ian on 2022/07/16.
//

import RxSwift

final class FavoritesViewModel {

  // MARK: - Properties
  private let useCase: FavoriteUseCase
  private(set) var favoriteItemList: [Item] = []

  init(useCase: FavoriteUseCase) {
    self.useCase = useCase
  }
}

extension FavoritesViewModel: ViewModelType {
  struct Input {
    let requestContents: Observable<Void>
  }

  struct Output {
    let didReceiveContents: Observable<Void>
  }

  func transform(_ input: Input) -> Output {
    let didReceiveContents = input.requestContents
      .flatMapLatest(fetchFavoriteItemList)

    return .init(didReceiveContents: didReceiveContents)
  }
}

// MARK: - Private
private extension FavoritesViewModel {
  func fetchFavoriteItemList() -> Observable<Void> {
    return useCase.fetchFavoriteItems()
      .do(onNext: { [weak self] in
        self?.favoriteItemList = $0
      })
      .map { _ in }
  }
}
