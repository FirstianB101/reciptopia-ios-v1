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
  private let sharedFavoriteBoardViewModel: FavoriteBoardViewModel
  
  // MARK: - Methods
  public init(superDependency: ReciptopiaDependencyContainer) {
    // search history
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
    
    // favorite board
    func makeFavoriteBoardDataStore() -> FavoriteBoardDataStore {
      return StorageFavoriteBoardDataStore()
    }
    
    func makeFavoriteBoardRepository() -> FavoriteBoardRepository {
      let favoriteBoardDataStore = makeFavoriteBoardDataStore()
      return DefaultFavoriteBoardRepository(favoriteBoardDataStore: favoriteBoardDataStore)
    }
    
    func makeFavoriteBoardViewModel() -> FavoriteBoardViewModel {
      let favoriteBoardRepository = makeFavoriteBoardRepository()
      return FavoriteBoardViewModel(favoriteBoardRepository: favoriteBoardRepository)
    }
    
    self.sharedSearchHistoryViewModel = makeSearchHistoryViewModel()
    self.sharedFavoriteBoardViewModel = makeFavoriteBoardViewModel()
  }
  
  // search ingredient
  func makeSearchIngredientViewController() -> SearchIngredientViewController {
    let viewModel = makeSearchIngredientViewModel()
    let searchHistoryRootView = makeSearchHistoryRootView()
    let favoriteBoardRootView = makeFavoriteBoardRootView()
    return SearchIngredientViewController(
      viewModel: viewModel,
      searchHistoryRootView: searchHistoryRootView,
      favoriteBoardRootView: favoriteBoardRootView
    )
  }
  
  func makeSearchIngredientViewModel() -> SearchIngredientViewModel {
    return SearchIngredientViewModel(saveHistoryResponder: sharedSearchHistoryViewModel)
  }
  
  // search history
  func makeSearchHistoryRootView() -> SearchHistoryRootView {
    return SearchHistoryRootView(viewModel: sharedSearchHistoryViewModel)
  }
  
  // favorite board
  func makeFavoriteBoardRootView() -> FavoriteBoardRootView {
    return FavoriteBoardRootView(viewModel: sharedFavoriteBoardViewModel)
  }
}
