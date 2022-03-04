//
//  IngredientEntities+Mapping.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/03/04.
//

import Foundation

extension IngredientEntities {
  func toDomain() -> [Ingredient] {
    return ingredients.map { $0.toDomain() }
  }
}
