//
//  GoodsAPI.swift
//  testApp
//
//  Created by Ian on 2022/07/16.
//

import Moya

enum GoodsAPI {
  case fetchContents
  case fetchGoods(lastId: String)
}

extension GoodsAPI: TargetType {
  var baseURL: URL {
    return URL(string: GlobalConstant.baseURL)!
  }

  var path: String {
    switch self {
    case .fetchContents:
      return ""
    case .fetchGoods:
      return "/goods"
    }
  }

  var method: Method {
    switch self {
    case .fetchContents, .fetchGoods(_):
      return .get
    }
  }

  var task: Task {
    let requestParameters = parameters ?? [:]
    let encoidng: ParameterEncoding

    switch self {
    case .fetchContents, .fetchGoods:
      encoidng = URLEncoding.default
    }

    return .requestParameters(parameters: requestParameters, encoding: encoidng)
  }

  var headers: [String : String]? {
    return nil
  }

  private var parameters: [String: Any]? {
    switch self {
    case .fetchContents:
      return nil
    case .fetchGoods(let lastId):
      return ["lastId": lastId]
    }
  }
}
