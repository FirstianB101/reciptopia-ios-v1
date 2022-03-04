//
//  ReciptopiaDependency.swift
//  Reciptopia_iOS
//
//  Created by 김세영 on 2022/02/21.
//

import Foundation
import ReciptopiaKit

public class ReciptopiaDependencyContainer {
  
  // MARK: - Properties
  private let sharedPictureIngredientRepository: PictureIngredientRepository
  private let sharedPictureIngredientViewModel: PictureIngredientViewModel
  private let sharedUserSessionRepository: UserSessionRepository
  
  // MARK: - Methods
  public init() {
    func makePictureIngredientRepository() -> PictureIngredientRepository {
      return FakePictureIngredientRepository()
    }
    
    func makeUserSessionDataStore() -> UserSessionDataStore {
      return FileBasedUserSessionDataStore()
    }
    
    func makeAuthRemoteAPI() -> AuthRemoteAPI {
      return FakeAuthRemoteAPI()
    }
    
    func makeUserSessionRepository() -> UserSessionRepository {
      let userSessionDataStore = makeUserSessionDataStore()
      let authRemoteAPI = makeAuthRemoteAPI()
      return DefaultUserSessionRepository(
        userSessionDataStore: userSessionDataStore,
        authRemoteAPI: authRemoteAPI
      )
    }
    
    self.sharedPictureIngredientRepository = makePictureIngredientRepository()
    self.sharedPictureIngredientViewModel = PictureIngredientViewModel(
      pictureIngredientRepository: sharedPictureIngredientRepository
    )
    self.sharedUserSessionRepository = makeUserSessionRepository()
  }
  
  // picture ingredient
  public func makePictureIngredientViewController() -> PictureIngredientViewController {
    let managePictureViewControllerFactory = {
      return self.makeManagePictureViewController()
    }
    let searchIngredientViewControllerFactory = {
      return self.makeSearchIngredientViewController()
    }
    
    return PictureIngredientViewController(
      viewModel: sharedPictureIngredientViewModel,
      managePictureViewControllerFactory: managePictureViewControllerFactory,
      searchIngredientViewControllerFactory: searchIngredientViewControllerFactory,
      checkIngredientViewControllerFactory: makeCheckIngredientViewController(withIngredients:)
    )
  }
  
  // manage picture
  func makeManagePictureViewController() -> ManagePictureViewController {
    return ManagePictureViewController(viewModel: sharedPictureIngredientViewModel)
  }
  
  // search ingredient (new dependency)
  func makeSearchIngredientViewController() -> SearchIngredientViewController {
    let searchIngredientDependency = SearchIngredientDependencyContainer(superDependency: self)
    return searchIngredientDependency.makeSearchIngredientViewController()
  }
  
  // check ingredient (new dependency)
  func makeCheckIngredientViewController(withIngredients ingredients: [Ingredient]) -> CheckIngredientViewController {
    let searchIngredientDependency = SearchIngredientDependencyContainer(superDependency: self)
    return searchIngredientDependency.makeCheckIngredientViewController(withIngredients: ingredients)
  }
}
