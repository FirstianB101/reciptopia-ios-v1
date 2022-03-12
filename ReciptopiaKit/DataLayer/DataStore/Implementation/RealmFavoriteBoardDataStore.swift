//
//  RealmFavoriteDataStore.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/03/12.
//

import Foundation
import PromiseKit

public final class RealmFavoriteBoardDataStore: FavoriteBoardDataStore {
  public init() {}
  
  public func fetch(_ page: Int) -> Promise<[Favorite]> {
    return RealmUtil.shared.read(objectType: FavoriteRealmEntity.self)
      .then(toDomain(_:))
  }
  
  public func save(_ favorite: Favorite) -> Promise<Favorite> {
    return RealmUtil.shared.create(favorite.toRealmEntity())
      .then(toDomain(_:))
  }
  
  public func delete(_ favorite: Favorite) -> Promise<Void> {
    guard let id = favorite.id else {
      return Promise(error: ReciptopiaError.deleteError)
    }
    return RealmUtil.shared.delete(id: id, ofType: FavoriteRealmEntity.self)
  }
  
  private func toDomain(_ entities: [FavoriteRealmEntity]) -> Promise<[Favorite]> {
    return Promise.value(entities.map { $0.toDomain() })
  }
  
  private func toDomain(_ entity: FavoriteRealmEntity) -> Promise<Favorite> {
    return Promise.value(entity.toDomain())
  }
}
