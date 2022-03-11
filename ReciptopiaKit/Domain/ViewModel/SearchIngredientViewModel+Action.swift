//
//  SearchIngredientViewModel.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/02/23.
//

import Foundation
import Combine
import PromiseKit

public enum SearchIngredientAction {
  case presentBoardList(boards: [Board])
  case dismiss
}

public class SearchIngredientViewModel: FetchBoardResponder, ErrorPublishable {
  
  // MARK: - Dependencies
  let searchBoardByIngredientUseCase: SearchBoardByIngredientUseCase
  
  // MARK: - Properties
  @Published public private(set) var ingredients = [Ingredient]()
  public let view = CurrentValueSubject<SearchIngredientView, Never>(.history)
  public let action = PassthroughSubject<SearchIngredientAction, Never>()
  public let alertPublisher = PassthroughSubject<AlertMessage, Never>()
  
  // MARK: - Methods
  public init(searchBoardByIngredientUseCase: SearchBoardByIngredientUseCase) {
    self.searchBoardByIngredientUseCase = searchBoardByIngredientUseCase
  }
  
  public func setIngredients(_ ingredients: [Ingredient]) {
    self.ingredients = ingredients
  }
  
  @objc public func removeIngredient(at index: Int) {
    ingredients.remove(at: index)
  }
  
  @objc public func addIngredient(_ ingredientName: String) {
    if alreadyContainsIngredient(ingredientName) {
      let alertMessage = AlertMessage(title: "알림", message: "이미 추가된 재료입니다.")
      alertPublisher.send(alertMessage)
      return
    }
    let ingredient = Ingredient(isMainIngredient: false, name: ingredientName, amount: "")
    ingredients.append(ingredient)
  }
  
  private func alreadyContainsIngredient(_ ingredientName: String) -> Bool {
    let ingredientNames = ingredients.map { $0.name }
    return ingredientNames.contains(ingredientName)
  }
  
  public func toggleMainOrSubIngredient(at index: Int) {
    ingredients[index].isMainIngredient = !ingredients[index].isMainIngredient
  }
  
  @objc public func dismiss() {
    action.send(.dismiss)
  }
  
  @objc public func searchByIngredients() {
    searchBoardByIngredientUseCase.searchBoard(byIngredients: ingredients)
      .done(presentBoard(_:))
      .catch(publishError(_:))
  }
  
  public func presentBoard(_ boards: [Board]) {
    ingredients = []
    action.send(.presentBoardList(boards: boards))
  }
  
  public func changeView(at segment: Int) {
    guard let segment = SearchIngredientView(rawValue: segment) else { return }
    view.send(segment)
    print(segment)
  }
}
