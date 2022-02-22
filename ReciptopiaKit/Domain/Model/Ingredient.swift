//
//  Ingredients.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/02/21.
//

import Foundation

public struct Ingredient {
  let isMainIngredient: Bool
  let name: String
  let amount: String
}

internal extension Ingredient {
  static func Stub(mainIngredient: Bool, name: String, amount: String) -> Self {
    return Ingredient(isMainIngredient: mainIngredient, name: name, amount: amount)
  }
}
