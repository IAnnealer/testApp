//
//  Banner.swift
//  testApp
//
//  Created by Ian on 2022/07/16.
//

import Foundation

struct ContentReponse: Codable {
  let banners: [Banner]
  var goods: [Item]
}

struct Banner: Codable {
  let id: Int
  let imageURLString: String

  var imageURL: URL {
    return URL(string: imageURLString)!
  }

  enum CodingKeys: String, CodingKey {
    case id
    case imageURLString = "image"
  }
}
