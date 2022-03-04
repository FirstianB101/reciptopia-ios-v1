//
//  IngredientEntity+Mapping.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/03/03.
//

import Foundation

extension IngredientEntity {
  func toDomain() -> Ingredient {
    return Ingredient(isMainIngredient: isMainIngredient, name: name, amount: amount)
  }
}

extension Ingredient {
  func toEntity() -> IngredientEntity {
    return IngredientEntity(name: name, isMainIngredient: isMainIngredient, amount: amount)
  }
}
