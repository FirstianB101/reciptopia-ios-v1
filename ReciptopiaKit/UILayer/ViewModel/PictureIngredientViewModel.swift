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
  case photoAlbum
  case checkIngredients(ingredients: [Ingredient])
}

public class PictureIngredientViewModel {
  
  // MARK: - Dependencies
  let pictureIngredientRepository: PictureIngredientRepository
  
  // MARK: - Properties
  public let action = PassthroughSubject<PictureIngredientAction, Never>()
  public let alertPublisher = PassthroughSubject<AlertMessage, Never>()
  public let pictureIngredients = CurrentValueSubject<[Data], Never>([])
  
  public var remainingPictureCount: Int {
    return 10 - pictureIngredients.value.count
  }
  
  private var waitForDeletionIndices = Set<Int>()
  
  // MARK: - Methods
  public init(pictureIngredientRepository: PictureIngredientRepository) {
    self.pictureIngredientRepository = pictureIngredientRepository
  }
  
  @objc public func analyzeIngredients() {
    let pictures = pictureIngredients.value
    pictureIngredientRepository.analyze(pictures)
      .done(presentCheckIngredients(_:))
      .catch(presentErrorMessage(_:))
  }
  
  @objc public func deleteIngredients() {
    waitForDeletionIndices.sorted(by: >).forEach { index in
      pictureIngredients.value.remove(at: index)
    }
    waitForDeletionIndices.removeAll()
  }
  
  private func presentCheckIngredients(_ ingredients: [Ingredient]) {
    action.send(.checkIngredients(ingredients: ingredients))
  }
  
  private func presentErrorMessage(_ error: Error) {
    alertPublisher.send(.makeErrorMessage())
  }
  
  @objc public func presentManagePicture() {
    action.send(.managePicture)
  }
  
  @objc public func presentPhotoAlbum() {
    action.send(.photoAlbum)
  }
  
  @objc public func presentSearch() {
    action.send(.search)
  }
  
  @objc public func presentNotification() {
    action.send(.notification)
  }
  
  public func addPicture(_ picture: Data) {
    pictureIngredients.value.append(picture)
  }
  
  public func addDeletion(at index: Int) {
    waitForDeletionIndices.insert(index)
  }
  
  public func removeDeletion(at index: Int) {
    if waitForDeletionIndices.contains(index) {
      waitForDeletionIndices.remove(index)
    }
  }
}
