//
//  IngredientEntity.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/03/03.
//

import Foundation
import CoreData

public class IngredientEntity: NSSecureUnarchiveFromDataTransformer, NSSecureCoding {
  
  public var name: String
  public var isMainIngredient: Bool
  public var amount: String
  
  public init(name: String, isMainIngredient: Bool, amount: String) {
    self.name = name
    self.isMainIngredient = isMainIngredient
    self.amount = amount
  }
  
  public func encode(with coder: NSCoder) {
    coder.encode(name, forKey: "name")
    coder.encode(isMainIngredient, forKey: "isMainIngredient")
    coder.encode(amount, forKey: "amount")
  }
  
  public required init?(coder: NSCoder) {
    name = coder.decodeObject(forKey: "name") as! String
    isMainIngredient = coder.decodeBool(forKey: "isMainIngredient")
    amount = coder.decodeObject(forKey: "amount") as! String
  }
  
  public override class var allowedTopLevelClasses: [AnyClass] {
    return [IngredientEntity.self]
  }
  
  public static var supportsSecureCoding: Bool {
    return true
  }
}

