//
//  Recipe.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/03/02.
//

import Foundation

public struct Recipe {
  public let id: Int?
  public let steps: [Step]
  public let ingredients: [Ingredient]
}
