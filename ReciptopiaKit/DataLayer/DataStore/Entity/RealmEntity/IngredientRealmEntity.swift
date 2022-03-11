//
//  IngredientRealmEntity.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/03/04.
//

import Foundation
import Realm
import RealmSwift

public class IngredientRealmEntity: Object {
  @Persisted
  var name: String = ""
  
  @Persisted
  var isMainIngredient: Bool = false
  
  @Persisted
  var amount: String = ""
  
  public convenience init(name: String, isMainIngredient: Bool, amount: String) {
    self.init()
    self.name = name
    self.isMainIngredient = isMainIngredient
    self.amount = amount
  }
}
