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
  case dismiss
}

public class SearchIngredientViewModel {
  
  // MARK: - Dependencies
  let searchHistoryRepository: SearchHistoryRepository
  
  // MARK: - Properties
  @Published public private(set) var searchHistories = [History]()
  @Published public private(set) var ingredients = [Ingredient]()
  public let action = PassthroughSubject<SearchIngredientAction, Never>()
  public let alertPublisher = PassthroughSubject<AlertMessage, Never>()
  private var historyPage = 0
  
  // MARK: - Methods
  public init(searchHistoryRepository: SearchHistoryRepository) {
    self.searchHistoryRepository = searchHistoryRepository
    fetchSearchHistory()
  }
  
  private func fetchSearchHistory() {
    searchHistoryRepository.fetch(historyPage)
      .done(sortSearchHistoryAndSend(_:))
      .catch(publishAlert(_:))
  }
  
  private func sortSearchHistoryAndSend(_ histories: [History]) {
    let sortedHistories = histories.sorted { $0.id! < $1.id! }
    searchHistories = sortedHistories
  }
  
  private func publishAlert(_ error: Error) {
    alertPublisher.send(.makeErrorMessage())
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
}
