//
//  CoreDataUtil.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/02/22.
//

import Foundation
import CoreData

public final class CoreDataUtil {
  
  // MARK: - Properties
  public static let shared = CoreDataUtil()
  
  // MARK: - CoreData Stack
  private lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "History")
    container.loadPersistentStores { (_, error) in
      if let error = error as NSError? {
        assertionFailure("Unresolved error \(error), \(error.userInfo)")
      }
    }
    return container
  }()
  
  var context: NSManagedObjectContext {
    return self.persistentContainer.viewContext
  }
  
  // MARK: - Saving
  func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let nserror = error as NSError
        assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
}
