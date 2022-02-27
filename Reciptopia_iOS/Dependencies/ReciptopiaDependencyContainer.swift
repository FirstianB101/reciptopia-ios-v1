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
  
  // MARK: - Methods
  public init() {
    func makePictureIngredientRepository() -> PictureIngredientRepository {
      return FakePictureIngredientRepository()
    }
    
    self.sharedPictureIngredientRepository = makePictureIngredientRepository()
    self.sharedPictureIngredientViewModel = PictureIngredientViewModel(
      pictureIngredientRepository: sharedPictureIngredientRepository
    )
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
      searchIngredientViewControllerFactory: searchIngredientViewControllerFactory
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
}
