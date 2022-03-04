//
//  SearchIngredientRepository.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/03/01.
//

import Foundation
import PromiseKit

public protocol SearchBoardByIngredientRepository {
  func searchBoards(by ingredients: [Ingredient]) -> Promise<[Board]>
}
