//
//  DefaultSearchHistoryRepository.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/02/22.
//

import Foundation
import PromiseKit

public final class DefaultSearchHistoryRepository: SearchHistoryRepository {
  
  // MARK: - Properties
  let searchHistoryDataStore: SearchHistoryDataStore
  
  // MARK: - Methods
  init(searchHistoryDataStore: SearchHistoryDataStore) {
    self.searchHistoryDataStore = searchHistoryDataStore
  }
  
  public func fetch(_ page: Int) -> Promise<[History]> {
    return searchHistoryDataStore.fetch(page)
  }
  
  public func save(_ history: History) -> Promise<History> {
    return searchHistoryDataStore.save(history)
  }
  
  public func delete(_ history: History) -> Promise<Void> {
    return searchHistoryDataStore.delete(history)
  }
  
  public func deleteAll() -> Promise<Void> {
    return searchHistoryDataStore.deleteAll()
  }
}
