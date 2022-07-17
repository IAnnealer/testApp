//
//  Item.swift
//  testApp
//
//  Created by Ian on 2022/07/16.
//

import Foundation

struct GoodsResponse: Codable {
  var goods: [Item]
}

struct Item: Codable {
  let id: Int
  let name: String
  let imageURLString: String
  let actualPrice: Int
  let price: Int
  let isNew: Bool
  let sellCount: Int

  var imageURL: URL {
    return URL(string: imageURLString)!
  }

  var discountRate: Int {
    return 100 - (price * 100 / actualPrice)
  }

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case price
    case imageURLString = "image"
    case actualPrice = "actual_price"
    case isNew = "is_new"
    case sellCount = "sell_count"
  }
}
