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
  
  // MARK: - Methods
  public init() {
    func makePictureIngredientRepository() -> PictureIngredientRepository {
      return FakePictureIngredientRepository()
    }
    
    self.sharedPictureIngredientRepository = makePictureIngredientRepository()
  }
  
  // picture ingredient
  public func makePictureIngredientViewController() -> PictureIngredientViewController {
    let viewModel = makePictureIngredientViewModel()
    return PictureIngredientViewController(viewModel: viewModel)
  }
  
  func makePictureIngredientViewModel() -> PictureIngredientViewModel {
    return PictureIngredientViewModel(pictureIngredientRepository: sharedPictureIngredientRepository)
  }
}
