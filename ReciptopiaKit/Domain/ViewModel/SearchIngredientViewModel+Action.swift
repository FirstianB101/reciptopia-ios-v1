//
//  SearchIngredientViewModel.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/02/23.
//

import Foundation
import Combine
import PromiseKit

public enum SearchIngredientAction: Int {
  case history = 0
  case favorite = 1
  case dismiss
}

public class SearchIngredientViewModel: ErrorPublishable {
  
  // MARK: - Dependencies
  let saveHistoryResponder: SaveIngredientResponder
  
  // MARK: - Properties
  @Published public private(set) var ingredients = [Ingredient]()
  public let action = CurrentValueSubject<SearchIngredientAction, Never>(.history)
  public let alertPublisher = PassthroughSubject<AlertMessage, Never>()
  
  // MARK: - Methods
  public init(saveHistoryResponder: SaveIngredientResponder) {
    self.saveHistoryResponder = saveHistoryResponder
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
    saveHistoryResponder.saveIngredients(ingredients)
  }
  
  public func changeView(at segment: Int) {
    guard let segment = SearchIngredientAction(rawValue: segment) else { return }
    action.send(segment)
    print(segment)
  }
}
