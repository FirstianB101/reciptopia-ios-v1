//
//  FavoriteEntity+Mapping.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/02/28.
//

import Foundation

extension FavoriteEntity {
  func toDomain() -> Favorite {
    return Favorite(id: Int(id), boardId: Int(boardId), boardTitle: boardTitle)
  }
}
