//
//  FavoriteRealmEntity+Mapping.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/03/04.
//

import Foundation

extension FavoriteRealmEntity {
  func toDomain() -> Favorite {
    return Favorite(id: id, boardId: boardId, boardTitle: boardTitle)
  }
}

extension Favorite {
  func toRealmEntity() -> FavoriteRealmEntity {
    return FavoriteRealmEntity(boardId: boardId, boardTitle: boardTitle)
  }
}
