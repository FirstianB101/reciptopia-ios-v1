//
//  FavoriteBoardViewModel.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/02/28.
//

import Foundation
import Combine
import PromiseKit

public class FavoriteBoardViewModel: ErrorPublishable {
  
  // MARK: - Dependencies
  let favoriteBoardRepository: FavoriteBoardRepository
  private var page = 0
  
  // MARK: - Properties
  public let alertPublisher = PassthroughSubject<AlertMessage, Never>()
  
  // MARK: - Methods
  public init(favoriteBoardRepository: FavoriteBoardRepository) {
    self.favoriteBoardRepository = favoriteBoardRepository
  }
  
  private func fetchFavoriteBoards() {
    favoriteBoardRepository.fetch(page)
      .done(sendFavoriteBoard(_:))
      .catch(publishError(_:))
  }
  
  private func sendFavoriteBoard(_ favorites: [Favorite]) {
    
  }
}
