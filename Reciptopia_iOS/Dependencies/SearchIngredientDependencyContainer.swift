//
//  SearchIngredientDependencyContainer.swift
//  Reciptopia_iOS
//
//  Created by 김세영 on 2022/02/27.
//

import Foundation
import ReciptopiaKit

public final class SearchIngredientDependencyContainer {
  
  // MARK: - Properties
  private let sharedSearchHistoryRepository: SearchHistoryRepository
  
  // MARK: - Methods
  public init(superDependency: ReciptopiaDependencyContainer) {
    func makeSearchHistoryDataStore() -> SearchHistoryDataStore {
      return StorageSearchHistoryDataStore()
    }
    
    func makeSearchHistoryRepository() -> SearchHistoryRepository {
      let searchHistoryDataStore = makeSearchHistoryDataStore()
      return DefaultSearchHistoryRepository(searchHistoryDataStore: searchHistoryDataStore)
    }
    
    self.sharedSearchHistoryRepository = makeSearchHistoryRepository()
  }
  
  // search ingredient
  func makeSearchIngredientViewController() -> SearchIngredientViewController {
    let viewModel = makeSearchIngredientViewModel()
    return SearchIngredientViewController(viewModel: viewModel)
  }
  
  func makeSearchIngredientViewModel() -> SearchIngredientViewModel {
    return SearchIngredientViewModel(searchHistoryRepository: sharedSearchHistoryRepository)
  }
}
