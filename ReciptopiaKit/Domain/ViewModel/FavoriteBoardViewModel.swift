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
  @Published public private(set) var favorites = [Favorite]()
  public let alertPublisher = PassthroughSubject<AlertMessage, Never>()
  
  // MARK: - Methods
  public init(favoriteBoardRepository: FavoriteBoardRepository) {
    self.favoriteBoardRepository = favoriteBoardRepository
    fetchFavoriteBoards()
  }
  
  private func fetchFavoriteBoards() {
    favoriteBoardRepository.fetch(page)
      .done(sendFavoriteBoard(_:))
      .catch(publishError(_:))
  }
  
  private func sendFavoriteBoard(_ favorites: [Favorite]) {
    self.favorites = favorites
  }
  
  public func deleteFavorite(at index: Int, completion: @escaping () -> Void) {
    let favorite = favorites[index]
    favoriteBoardRepository.delete(favorite)
      .done { [weak self] _ in
        self?.favorites.remove(at: index)
        completion()
      }.catch(publishError(_:))
  }
}
