//
//  ItemTest.swift
//  testAppTests
//
//  Created by Ian on 2022/07/20.
//

import Foundation

import Quick
import Nimble
@testable import testApp


class ItemTests: QuickSpec {

  override func spec() {
    let id = 2
    let actualPrice = 34000
    let image = "https://d20s70j9gw443i.cloudfront.net/t_GOODS_THUMB_WEBP/https://imgb.a-bly.com/data/goods/20210201_1612166334342099s.jpg"
    let price = 16000
    let sellCount = 61
    let isNew = true
    let name = "[당일출고]왕박시핏!스트링 야삿 자켓"

    describe("converts from JSON") {
      var item: Item?

      context("try JSONSerialization & Decoding") {
        let json: [String: Any] = ["id": id, "actual_price": actualPrice, "image": image,
                                   "sell_count": sellCount, "price": price, "is_new": isNew, "name": name]
        do {
          let itemData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
          item = try JSONDecoder().decode(Item.self, from: itemData)
        } catch {
          fail()
        }

        it("Item") {
          expect(item?.id).to(equal(id))
          expect(item?.actualPrice).to(equal(actualPrice))
          expect(item?.imageURLString).to(equal(image))
          expect(item?.isNew).to(equal(isNew))
          expect(item?.price).to(equal(price))
          expect(item?.name).to(equal(name))
          expect(item?.sellCount).to(equal(sellCount))
        }
      }
    }
  }
}
