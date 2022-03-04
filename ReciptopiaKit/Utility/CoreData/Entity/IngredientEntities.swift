//
//  IngredientEntities.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/03/04.
//

import Foundation

public class IngredientEntities: NSSecureUnarchiveFromDataTransformer, NSSecureCoding {
  
  public static var supportsSecureCoding: Bool = true
  
  public var ingredients = [IngredientEntity]()
  
  init(ingredients: [IngredientEntity]) {
    self.ingredients = ingredients
  }
  
  public func encode(with coder: NSCoder) {
    coder.encode(ingredients, forKey: "ingredients")
  }
  
  public required convenience init?(coder: NSCoder) {
    let ingredients = coder.decodeObject(forKey: "ingredients") as! [IngredientEntity]
    
    self.init(ingredients: ingredients)
  }
}
