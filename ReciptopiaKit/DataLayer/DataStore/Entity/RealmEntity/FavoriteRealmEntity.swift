//
//  FavoriteRealmEntity.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/03/04.
//

import Foundation
import Realm
import RealmSwift

public class FavoriteRealmEntity: Object, RealmIdentifiable {
  @Persisted(primaryKey: true)
  var id: Int = 0
  
  @Persisted
  var boardId: Int = 0
  
  @Persisted
  var boardTitle: String = ""
  
  public convenience init(boardId: Int, boardTitle: String) {
    self.init()
    self.boardId = boardId
    self.boardTitle = boardTitle
    self.incrementId()
  }
}
