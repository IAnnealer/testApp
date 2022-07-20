//
//  BannerTest.swift
//  testAppTests
//
//  Created by Ian on 2022/07/20.
//

import Quick
import Nimble
@testable import testApp

class BannerTests: QuickSpec {

  override func spec() {
    let id = 1;
    let imageUrlString = "https://img.a-bly.com/banner/images/banner_image_1615465448476691.jpg"

    describe("converts from JSON") {
      var banner: Banner?

      context("try JSONSecorialzation & Decoding") {
        let json: [String: Any] = ["id": id, "image": imageUrlString]

        do {
          let bannerJson = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
          banner = try JSONDecoder().decode(Banner.self, from: bannerJson)
        } catch {
          fail()
        }

        it("Banner") {
          expect(banner?.id).to(equal(id))
          expect(banner?.imageURLString).to(equal(imageUrlString))
        }
      }
    }
  }
}

