//
//  UIColorExtension.swift
//  Reciptopia_UIKit
//
//  Created by 김세영 on 2022/02/22.
//

import Foundation

extension UIColor {
  public convenience init(_ hex: Int) {
    guard 0...0xFFFFFF ~= hex else {
      fatalError("the given value \(hex) is not RGB values.")
    }
    let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
    let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
    let blue = CGFloat((hex & 0x0000FF)) / 255.0
    self.init(red: red, green: green, blue: blue, alpha: 1.0)
  }
  
  public static let accentColor = UIColor(0x5F8FED)
  public static let collectionBackground = UIColor(0xE5E5E5)
  public static let mainIngredient = UIColor(0xEAAD11)
  public static let searchHistoryTint = UIColor(0xBEBEF0)
  public static let favoriteStarTint = UIColor(0xEFDD3F)
}
