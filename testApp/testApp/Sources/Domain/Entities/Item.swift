//
//  Item.swift
//  testApp
//
//  Created by Ian on 2022/07/16.
//

import RealmSwift

struct GoodsResponse: Codable {
  var goods: [Item]
}

class Item: Object, Codable {
  @objc dynamic var id: Int
  @objc dynamic var name: String
  @objc dynamic var imageURLString: String
  @objc dynamic var actualPrice: Int
  @objc dynamic var price: Int
  @objc dynamic var isNew: Bool
  @objc dynamic var sellCount: Int

  var imageURL: URL {
    return URL(string: imageURLString)!
  }

  var discountRate: Int {
    return 100 - (price * 100 / actualPrice)
  }

  convenience init(
    id: Int,
    name: String,
    imageURLString: String,
    actualPrice: Int,
    price: Int,
    isNew: Bool,
    sellCount: Int
  ) {
    self.init()
    self.id = id
    self.name = name
    self.imageURLString = imageURLString
    self.actualPrice = actualPrice
    self.price = price
    self.isNew = isNew
    self.sellCount = sellCount
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
