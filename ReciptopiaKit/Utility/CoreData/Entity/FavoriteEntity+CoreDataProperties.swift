//
//  FavoriteEntity+CoreDataProperties.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/02/22.
//
//

import Foundation
import CoreData


extension FavoriteEntity {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteEntity> {
    return NSFetchRequest<FavoriteEntity>(entityName: "FavoriteEntity")
  }
  
  @NSManaged public var boardId: Int64
  @NSManaged public var boardTitle: String
  @NSManaged public var id: Int64
  
}

extension FavoriteEntity : Identifiable {
  
}
