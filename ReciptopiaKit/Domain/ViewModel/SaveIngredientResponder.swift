//
//  SaveIngredientResponder.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/02/28.
//

import Foundation
import PromiseKit

public protocol SaveIngredientResponder {
  func save(ingredients: [Ingredient])
}
