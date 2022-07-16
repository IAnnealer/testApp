//
//  Array+.swift
//  testApp
//
//  Created by Ian on 2022/07/16.
//

import Foundation

public extension Array {
  subscript (safe index: Int) -> Element? {
      return indices ~= index ? self[index] : nil
  }
}
