//
//  SearchHistoryViewModel.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/02/28.
//

import Foundation
import Combine
import PromiseKit

public class SearchHistoryViewModel: SaveIngredientResponder, ErrorPublishable {
  
  // MARK: - Dependencies
  let searchHistoryRepository: SearchHistoryRepository
  
  // MARK: - Properties
  @Published public private(set) var searchHistories = [History]()
  public let alertPublisher = PassthroughSubject<AlertMessage, Never>()
  public let reloadTrigger = PassthroughSubject<Void, Never>()
  private var page = 0
  
  // MARK: - Methods
  public init(searchHistoryRepository: SearchHistoryRepository) {
    self.searchHistoryRepository = searchHistoryRepository
    fetchSearchHistory()
  }
  
  private func fetchSearchHistory() {
    searchHistoryRepository.fetch(page)
      .done(sendSearchHistories(_:))
      .catch(publishError(_:))
  }
  
  private func sendSearchHistories(_ histories: [History]) {
    searchHistories = histories
  }
  
  public func deleteHistory(at index: Int, completion: @escaping () -> Void) {
    let history = searchHistories[index]
    
    searchHistoryRepository.delete(history)
      .done { [weak self] _ in
        self?.searchHistories.remove(at: index)
        completion()
      }.catch(publishError(_:))
  }
  
  public func saveIngredients(_ ingredients: [Ingredient]) {
    let ingredientsName = ingredients.map { $0.name }
    let history = History(id: nil, ingredients: ingredientsName)
    
    searchHistoryRepository.save(history)
      .done(appendSavedHistory(_:))
      .catch(publishError(_:))
  }
  
  private func appendSavedHistory(_ history: History) {
    searchHistories.append(history)
    reloadTrigger.send(())
  }
}
