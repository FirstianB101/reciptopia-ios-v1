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
  private let sharedSearchIngredientViewModel: SearchIngredientViewModel
  private let sharedSearchHistoryRepository: SearchHistoryRepository
  private let sharedSearchBoardListUseCase: SearchBoardListUseCase
  
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
    
    func makeSearchBoardByIngredientRepository() -> SearchBoardByIngredientRepository {
      return FakeSearchBoardByIngredientRepository()
    }
    
    self.sharedSearchHistoryRepository = makeSearchHistoryRepository()
    
    let searchBoardByIngredientRepository = makeSearchBoardByIngredientRepository()
    self.sharedSearchBoardListUseCase = DefaultSearchBoardListUseCase(
      searchBoardByIngredientRepository: searchBoardByIngredientRepository,
      searchHistoryRepository: sharedSearchHistoryRepository
    )
    
    self.sharedSearchIngredientViewModel = SearchIngredientViewModel(
      searchBoardListUseCase: sharedSearchBoardListUseCase
    )
  }
  
  // search ingredient
  func makeSearchIngredientViewController() -> SearchIngredientViewController {
    let searchHistoryRootView = makeSearchHistoryRootView()
    let favoriteBoardRootView = makeFavoriteBoardRootView()
    return SearchIngredientViewController(
      viewModel: sharedSearchIngredientViewModel,
      searchHistoryRootView: searchHistoryRootView,
      favoriteBoardRootView: favoriteBoardRootView
    )
  }
  
  // search history
  func makeSearchHistoryRootView() -> SearchHistoryRootView {
    let searchHistoryViewModel = makeSearchHistoryViewModel()
    return SearchHistoryRootView(viewModel: searchHistoryViewModel)
  }
  
  func makeSearchHistoryViewModel() -> SearchHistoryViewModel {
    return SearchHistoryViewModel(
      searchHistoryRepository: sharedSearchHistoryRepository,
      searchBoardListUseCase: sharedSearchBoardListUseCase,
      fetchBoardResponder: sharedSearchIngredientViewModel
    )
  }
  
  // favorite board
  func makeFavoriteBoardRootView() -> FavoriteBoardRootView {
    let favoriteBoardViewModel = makeFavoriteBoardViewModel()
    return FavoriteBoardRootView(viewModel: favoriteBoardViewModel)
  }
  
  func makeFavoriteBoardViewModel() -> FavoriteBoardViewModel {
    let favoriteBoardRepository = makeFavoriteBoardRepository()
    return FavoriteBoardViewModel(favoriteBoardRepository: favoriteBoardRepository)
  }
  
  func makeFavoriteBoardRepository() -> FavoriteBoardRepository {
    let favoriteBoardDataStore = makeFavoriteBoardDataStore()
    return DefaultFavoriteBoardRepository(favoriteBoardDataStore: favoriteBoardDataStore)
  }
  
  func makeFavoriteBoardDataStore() -> FavoriteBoardDataStore {
    return StorageFavoriteBoardDataStore()
  }
  
  // check ingredient
  func makeCheckIngredientViewController(withIngredients ingredients: [Ingredient]) -> CheckIngredientViewController {
    sharedSearchIngredientViewModel.setIngredients(ingredients)
    let searchIngredientViewController = makeSearchIngredientViewController()
    return CheckIngredientViewController(
      viewModel: sharedSearchIngredientViewModel,
      searchIngredientViewController: searchIngredientViewController
    )
  }
}
