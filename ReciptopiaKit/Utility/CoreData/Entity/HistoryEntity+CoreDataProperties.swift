//
//  HistoryEntity+CoreDataProperties.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/02/22.
//
//

import Foundation
import CoreData


extension HistoryEntity {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<HistoryEntity> {
    return NSFetchRequest<HistoryEntity>(entityName: "HistoryEntity")
  }
  
  @NSManaged public var ingredients: IngredientEntities
  @NSManaged public var id: Int64
}

extension HistoryEntity : Identifiable {
  
}
