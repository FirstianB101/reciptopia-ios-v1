//
//  FakePictureIngredientRepository.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/02/21.
//

import Foundation
import PromiseKit

public final class FakePictureIngredientRepository: PictureIngredientRepository {
  
  private let ingredientList: [Ingredient] = [
    Ingredient.Stub(mainIngredient: true, name: "스팸", amount: "1/2통"),
    Ingredient.Stub(mainIngredient: true, name: "다진 마늘", amount: "2스푼"),
    Ingredient.Stub(mainIngredient: true, name: "김치", amount: "1/2포기"),
    Ingredient.Stub(mainIngredient: false, name: "파", amount: "1주먹"),
  ]
  
  public init() {}
  
  public func analyze(_ pictures: [Data]) -> Promise<[Ingredient]> {
    return Promise.value(ingredientList)
  }
}
