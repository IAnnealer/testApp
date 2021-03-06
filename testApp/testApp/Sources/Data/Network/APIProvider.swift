//
//  APIProvider.swift
//  testApp
//
//  Created by Ian on 2022/07/16.
//

import Moya
import RxSwift

enum APIProvider {
  private static let moyaProvider: MoyaProvider<MultiTarget> = .init(
    plugins: [CustomPlugin()],
    trackInflights: true
  )

  static func request(_ target: TargetType,
                      callBackQueue: DispatchQueue? = nil) -> Single<Response> {
    return moyaProvider.rx.request(MultiTarget(target), callbackQueue: callBackQueue)
  }
}

struct CustomPlugin: PluginType {
  func willSend(_ request: RequestType, target: TargetType) {
#if DEBUG
    guard let request = request.request, let method = request.method else {
      return
    }
    print("[Moya-Logger] willSend - @\(method.rawValue): \(request.debugDescription)")
    print("[Moya-Logger] headers: \(String(describing: target.headers))")
    print("\n")
#endif
  }

  func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
#if DEBUG
    print("[Moya-Logger] didReceive - \(target.baseURL)\(target.path)")
    switch result {
    case .success(let response):
      guard let json = try? response.mapJSON() as? [String: Any] else {
        return
      }
      print("[Moya-Logger] 🟢 SUCCESS: \(json)")
    case .failure(let error):
      print("""
            [Moya-Logger] 🔴 FAIL: \(error.errorCode) -
            \(String(describing: error.errorDescription))
      """)
    }
    print("\n")
#endif
  }
}
