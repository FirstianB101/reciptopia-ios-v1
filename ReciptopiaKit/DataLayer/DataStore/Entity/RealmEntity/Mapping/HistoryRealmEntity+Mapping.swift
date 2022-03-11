//
//  HistoryRealmEntity+Mapping.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/03/04.
//

import Foundation

extension HistoryRealmEntity {
  func toDomain() -> History {
    let ingredients = Array(ingredients).map {
      Ingredient(isMainIngredient: $0.isMainIngredient, name: $0.name, amount: $0.amount)
    }
    
    return History(id: id, ingredients: ingredients)
  }
}

extension History {
  func toRealmEntity() -> HistoryRealmEntity {
    let ingredients = ingredients.map {
      IngredientRealmEntity(name: $0.name, isMainIngredient: $0.isMainIngredient, amount: $0.amount)
    }
    return HistoryRealmEntity(ingredients: ingredients)
  }
}
