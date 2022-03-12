//
//  DefaultSearchBoardListUseCase.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/03/03.
//

import Foundation
import PromiseKit

public final class DefaultSearchBoardListUseCase: SearchBoardListUseCase {
  
  // MARK: - Dependencies
  let searchBoardByIngredientRepository: SearchBoardByIngredientRepository
  let searchHistoryRepository: SearchHistoryRepository
  
  // MARK: - Properties
  
  // MARK: - Methods
  public init(
    searchBoardByIngredientRepository: SearchBoardByIngredientRepository,
    searchHistoryRepository: SearchHistoryRepository
  ) {
    self.searchBoardByIngredientRepository = searchBoardByIngredientRepository
    self.searchHistoryRepository = searchHistoryRepository
  }
  
  public func searchBoard(byIngredients ingredients: [Ingredient]) -> Promise<[Board]> {
    return saveHistory(ingredients)
      .then { [weak self] _ -> Promise<[Board]> in
        guard let strongSelf = self else { return Promise(error: ReciptopiaError.unknown) }
        return strongSelf.searchBoardByIngredientRepository.searchBoards(by: ingredients)
      }
  }
  
  private func saveHistory(_ ingredients: [Ingredient]) -> Promise<History> {
    let history = History(id: nil, ingredients: ingredients, timestamp: Date.timestamp())
    return searchHistoryRepository.save(history)
  }
}
