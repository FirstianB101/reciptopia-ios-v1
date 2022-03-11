//
//  HistoryRealmEntity.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/03/04.
//

import Foundation
import Realm
import RealmSwift

public class HistoryRealmEntity: Object, RealmIdentifiable {
  @Persisted(primaryKey: true)
  var id: Int = 0
  
  @Persisted
  var ingredients = List<IngredientRealmEntity>()
  
  @Persisted
  var timestamp: String
  
  public convenience init(ingredients: [IngredientRealmEntity], timestamp: String) {
    self.init()
    self.ingredients.append(objectsIn: ingredients)
    self.timestamp = timestamp
    self.incrementId()
    print("\(#function) -> id: \(id)")
  }
}
