//
//  SearchHistoryViewModel.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/02/28.
//

import Foundation
import Combine
import PromiseKit

public class SearchHistoryViewModel: ErrorPublishable {
  
  // MARK: - Dependencies
  let searchHistoryRepository: SearchHistoryRepository
  let searchBoardListUseCase: SearchBoardListUseCase
  let fetchBoardResponder: FetchBoardResponder
  
  // MARK: - Properties
  @Published public private(set) var searchHistories = [History]()
  public let alertPublisher = PassthroughSubject<AlertMessage, Never>()
  public let reloadTrigger = PassthroughSubject<Void, Never>()
  private var page = 0
  
  // MARK: - Methods
  public init(
    searchHistoryRepository: SearchHistoryRepository,
    searchBoardListUseCase: SearchBoardListUseCase,
    fetchBoardResponder: FetchBoardResponder
  ) {
    self.searchHistoryRepository = searchHistoryRepository
    self.searchBoardListUseCase = searchBoardListUseCase
    self.fetchBoardResponder = fetchBoardResponder
    fetchSearchHistory()
  }
  
  private func fetchSearchHistory() {
    searchHistoryRepository.fetch(page)
      .done(sendSearchHistories(_:))
      .catch(publishError(_:))
  }
  
  private func sendSearchHistories(_ histories: [History]) {
    searchHistories = histories
    reloadTrigger.send(())
  }
  
  public func deleteHistory(at index: Int, completion: @escaping () -> Void) {
    let history = searchHistories[index]
    
    searchHistoryRepository.delete(history)
      .done { [weak self] _ in
        self?.searchHistories.remove(at: index)
        completion()
      }.catch(publishError(_:))
  }
  
  public func searchIngredientByHistory(at index: Int) {
    let ingredients = searchHistories[index].ingredients
    searchBoardListUseCase.searchBoard(byIngredients: ingredients)
      .done { [weak self] boards in
        self?.fetchSearchHistory()
        self?.fetchBoardResponder.presentBoard(boards)
      }.catch(publishError(_:))
  }
}
