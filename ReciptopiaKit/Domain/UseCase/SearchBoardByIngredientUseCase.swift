//
//  SearchBoardByIngredientUseCase.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/03/03.
//

import Foundation
import PromiseKit

public protocol SearchBoardByIngredientUseCase {
  func searchBoard(byIngredients ingredients: [Ingredient]) -> Promise<[Board]>
}
