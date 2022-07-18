//
//  CGSIze+.swift
//  testApp
//
//  Created by Ian on 2022/07/17.
//

import UIKit

extension CGSize {
  /// 더미 Label과 구매중 노출 여부를 기반으로 셀의 사이즈를 계산하여 반환합니다.
  /// - Parameters:
  ///   - width: 셀의 넓이.
  ///   - defaultHeight: 셀의 기본 높이.
  ///   - item: 셀 모델.
  /// - Returns: 계산된 사이즈.
  static func calcuateGoodsCellSize(width: CGFloat, defaultHeight: CGFloat, item: Item) -> CGSize {
    var totalHeight: CGFloat = defaultHeight

    let label: UILabel = .init()
    label.font = GoodsCell.nameLabelFont
    label.numberOfLines = 0
    label.text = item.name
    label.sizeToFit()

    if item.isNew || item.sellCount > 10 {
      totalHeight += 20
    }

    totalHeight += (label.frame.width / GoodsCell.nameLabelWidth) * label.frame.height

    return .init(width: width, height: totalHeight)
  }
}
