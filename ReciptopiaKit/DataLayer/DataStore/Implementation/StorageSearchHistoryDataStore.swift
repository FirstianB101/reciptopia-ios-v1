//
//  StorageSearchHistoryDataStore.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/02/22.
//

import Foundation
import PromiseKit
import CoreData

public final class StorageSearchHistoryDataStore: SearchHistoryDataStore {
  
  // MARK: - Properties
  private let coreDataStorage = CoreDataUtil.shared
  
  private var historyId = "historyId"
  private var newHistoryId: Int {
    let newId = UserDefaults.standard.integer(forKey: historyId) + 1
    UserDefaults.standard.set(newId, forKey: historyId)
    UserDefaults.standard.synchronize()
    print("\(Self.self) -> newHistoryId: \(newId)")
    return newId
  }
  
  // MARK: - Methods
  public init() {}
  
  public func fetch(_ page: Int) -> Promise<[History]> {
    return Promise<[History]> { seal in
      do {
        let fetchRequest = HistoryEntity.fetchRequest()
        let histories = try coreDataStorage.context
          .fetch(fetchRequest)
          .map { $0.toDomain() }
        
        seal.fulfill(histories)
      } catch {
        assertionFailure("\(error) - \((error as NSError).userInfo)")
        seal.reject(CoreDataError.fetchError)
      }
    }
  }
  
  public func save(_ history: History) -> Promise<History> {
    return Promise<History> { seal in
      let entity = NSEntityDescription.entity(forEntityName: "HistoryEntity", in: coreDataStorage.context)
      if let entity = entity {
        let managedObject = NSManagedObject(entity: entity, insertInto: coreDataStorage.context)
        let id = newHistoryId
        managedObject.setValue(history.ingredients, forKey: "ingredients")
        managedObject.setValue(id, forKey: "id")
        do {
          try coreDataStorage.context.save()
          seal.fulfill(history)
        } catch {
          seal.reject(CoreDataError.saveError)
        }
      } else {
        seal.reject(CoreDataError.saveError)
      }
    }
  }
  
  public func delete(_ history: History) -> Promise<Void> {
    return Promise<Void> { seal in
      guard let id = history.id else {
        print("\(Self.self) delete(_:) - history id is nil.")
        seal.reject(CoreDataError.deleteError)
        return
      }
      do {
        let fetchRequest = HistoryEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %i", id)
        if let fetchResult = try coreDataStorage.context.fetch(fetchRequest).first {
          coreDataStorage.context.delete(fetchResult)
          seal.fulfill(())
        } else {
          seal.reject(CoreDataError.deleteError)
        }
      } catch {
        seal.reject(CoreDataError.deleteError)
      }
    }
  }
  
  public func deleteAll() -> Promise<Void> {
    return Promise<Void> { seal in
      let request: NSFetchRequest<NSFetchRequestResult> = HistoryEntity.fetchRequest()
      let delete = NSBatchDeleteRequest(fetchRequest: request)
      do {
        try coreDataStorage.context.execute(delete)
        seal.fulfill(())
      } catch {
        seal.reject(CoreDataError.deleteError)
      }
    }
  }
}
