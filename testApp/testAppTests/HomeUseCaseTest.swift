//
//  HomeUseCaseTest.swift
//  testAppTests
//
//  Created by Ian on 2022/07/20.
//

import Quick
import Nimble
import RxNimble
import RxTest
import RxSwift
import XCTest
@testable import testApp

class HomeUseCaseTest: QuickSpec {

  let useCase: HomeUseCase = DefaultHomeUseCase()
  var output: HomeViewModel.Output!

  var item: Item = .init(
    id: 1,
    name: "TEST Name",
    imageURLString: "https://d20s70j9gw443i.cloudfront.net/t_GOODS_THUMB_WEBP/https://imgb.a-bly.com/data/goods/20210122_1611290798811044s.jpg",
    actualPrice: 34000,
    price: 34000,
    isNew: false,
    sellCount: 58)

  override func spec() {
    var viewModel: HomeViewModel = .init(useCase: useCase)
    var scheduler: TestScheduler = .init(initialClock: 0)
    var disposeBag: DisposeBag = .init()

    let requestInitialContentsSubject: PublishSubject<Void> = .init()
    let requestExtraContentsSubject: PublishSubject<Void> = .init()
    let addFavoriteItemSubject: PublishSubject<Item> = .init()
    let deleteFavoriteItemSubject: PublishSubject<Item> = .init()

    output = viewModel.transform(
      .init(requestInitialContents: requestInitialContentsSubject.asObservable(),
            requestExtraContents: requestExtraContentsSubject.asObservable(),
            addFavoriteItem: addFavoriteItemSubject.asObservable(),
            deleteFavoriteItem: deleteFavoriteItemSubject.asObservable()
           )
    )

    output.didReceiveInitialContents.subscribe().disposed(by: disposeBag)
    output.didReceiveExtraContents.subscribe().disposed(by: disposeBag)
    output.didChangeFavoriteItemStatus.subscribe().disposed(by: disposeBag)

    describe("Home UseCase UnitTest") {

      beforeEach {
        viewModel = .init(useCase: self.useCase)
        disposeBag = .init()
        scheduler = .init(initialClock: 0)
      }

      context("Fetch Initial Contents") {
        scheduler.createColdObservable([.next(5, ())])
          .bind(to: requestInitialContentsSubject).disposed(by: disposeBag)

        it("Banners's count shoud not be zero") {
          expect(self.useCase.fetchContents().map { $0.banners.count })
            .events(scheduler: scheduler, disposeBag: disposeBag)
            .toNot(equal([.next(5, 0)]))
        }

        it("Goods's count shoud not be zero") {
          expect(self.useCase.fetchContents().map { $0.goods.count })
            .events(scheduler: scheduler, disposeBag: disposeBag)
            .toNot(equal([.next(5, 0)]))
        }
      }

      context("Fetch Extra Contents") {
        scheduler.createColdObservable([.next(10, ())])
          .bind(to: requestExtraContentsSubject).disposed(by: disposeBag)

        it("Goods's count shoud not be zero if API Parater `lsatId` is 10") {
          expect(self.useCase.fetchMoreGoods(lastId: 10).map { $0.goods.count })
            .events(scheduler: scheduler, disposeBag: disposeBag)
            .toNot(equal([.next(10, 0)]))
        }
      }
    }
  }
}


