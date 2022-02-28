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
  private let sharedSearchHistoryViewModel: SearchHistoryViewModel
  
  // MARK: - Methods
  public init(superDependency: ReciptopiaDependencyContainer) {
    func makeSearchHistoryDataStore() -> SearchHistoryDataStore {
      return StorageSearchHistoryDataStore()
    }
    
    func makeSearchHistoryRepository() -> SearchHistoryRepository {
      let searchHistoryDataStore = makeSearchHistoryDataStore()
      return DefaultSearchHistoryRepository(searchHistoryDataStore: searchHistoryDataStore)
    }
    
    func makeSearchHistoryViewModel() -> SearchHistoryViewModel {
      let searchHistoryRepository = makeSearchHistoryRepository()
      return SearchHistoryViewModel(searchHistoryRepository: searchHistoryRepository)
    }
    
    self.sharedSearchHistoryViewModel = makeSearchHistoryViewModel()
  }
  
  // search ingredient
  func makeSearchIngredientViewController() -> SearchIngredientViewController {
    let viewModel = makeSearchIngredientViewModel()
    let searchHistoryRootView = makeSearchHistoryRootView()
    return SearchIngredientViewController(
      viewModel: viewModel,
      searchHistoryRootView: searchHistoryRootView
    )
  }
  
  func makeSearchIngredientViewModel() -> SearchIngredientViewModel {
    return SearchIngredientViewModel(saveHistoryResponder: sharedSearchHistoryViewModel)
  }
  
  // search history
  func makeSearchHistoryRootView() -> SearchHistoryRootView {
    return SearchHistoryRootView(viewModel: sharedSearchHistoryViewModel)
  }
}
