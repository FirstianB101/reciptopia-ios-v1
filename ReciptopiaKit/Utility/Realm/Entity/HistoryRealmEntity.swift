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
  
  public convenience init(ingredients: [IngredientRealmEntity]) {
    self.init()
    self.ingredients.append(objectsIn: ingredients)
    self.incrementId()
    print("\(#function) -> id: \(id)")
  }
  
  func incrementId() {
    let realm = RealmUtil.shared.realm
    self.id = (realm.objects(Self.self).max(ofProperty: "id") as Int? ?? 0) + 1
  }
}
