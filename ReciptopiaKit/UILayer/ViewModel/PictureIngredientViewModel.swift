//
//  PictureIngredientViewModel.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/02/21.
//

import Foundation
import Combine
import PromiseKit

public enum PictureIngredientAction {
  case search
  case managePicture
  case notification
  case community
  case checkIngredients(ingredients: [Ingredient])
}

public class PictureIngredientViewModel {
  
  // MARK: - Dependencies
  let pictureIngredientRepository: PictureIngredientRepository
  
  // MARK: - Properties
  let action = PassthroughSubject<PictureIngredientAction, Never>()
  let alertPublisher = PassthroughSubject<AlertMessage, Never>()
  let pictureIngredients = CurrentValueSubject<[Data], Never>([])
  
  // MARK: - Methods
  public init(pictureIngredientRepository: PictureIngredientRepository) {
    self.pictureIngredientRepository = pictureIngredientRepository
  }
  
  @objc public func analyzePictures() {
    let pictures = pictureIngredients.value
    pictureIngredientRepository.analyze(pictures)
      .done(presentCheckIngredients(_:))
      .catch(presentErrorMessage(_:))
  }
  
  private func presentCheckIngredients(_ ingredients: [Ingredient]) {
    action.send(.checkIngredients(ingredients: ingredients))
  }
  
  private func presentErrorMessage(_ error: Error) {
    alertPublisher.send(.makeErrorMessage())
  }
}
