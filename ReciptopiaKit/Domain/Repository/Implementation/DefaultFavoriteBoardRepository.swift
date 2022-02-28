//
//  DefaultFavoriteBoardRepository.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/02/28.
//

import Foundation
import PromiseKit

public final class DefaultFavoriteBoardRepository: FavoriteBoardRepository {
  
  // MARK: - Properties
  let favoriteBoardDataStore: FavoriteBoardDataStore
  
  // MARK: - Methods
  public init(favoriteBoardDataStore: FavoriteBoardDataStore) {
    self.favoriteBoardDataStore = favoriteBoardDataStore
  }
  
  public func fetch(_ page: Int) -> Promise<[Favorite]> {
    return favoriteBoardDataStore.fetch(page)
  }
  
  public func save(_ favorite: Favorite) -> Promise<Favorite> {
    return favoriteBoardDataStore.save(favorite)
  }
  
  public func delete(_ favorite: Favorite) -> Promise<Void> {
    return favoriteBoardDataStore.delete(favorite)
  }
}
