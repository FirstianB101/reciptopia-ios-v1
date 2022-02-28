//
//  StorageSearchHistoryDataStore.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/02/22.
//

import Foundation
import PromiseKit
import CoreData

public final class StorageFavoriteBoardDataStore: FavoriteBoardDataStore {
  
  // MARK: - Properties
  private let coreDataStorage = CoreDataUtil.shared
  
  private var favoriteId = "favoriteId"
  private var newFavoriteId: Int {
    let newId = UserDefaults.standard.integer(forKey: favoriteId) + 1
    UserDefaults.standard.set(newId, forKey: favoriteId)
    UserDefaults.standard.synchronize()
    print("\(Self.self) -> newHistoryId: \(newId)")
    return newId
  }
  
  // MARK: - Methods
  public init() {}
  
  public func fetch(_ page: Int) -> Promise<[Favorite]> {
    return Promise<[Favorite]> { seal in
      do {
        let fetchRequest = FavoriteEntity.fetchRequest()
        let favorites = try coreDataStorage.context
          .fetch(fetchRequest)
          .map { $0.toDomain() }
        
        seal.fulfill(favorites)
      } catch {
        assertionFailure("\(error) - \((error as NSError).userInfo)")
        seal.reject(CoreDataError.fetchError)
      }
    }
  }
  
  public func save(_ favorite: Favorite) -> Promise<Favorite> {
    return Promise<Favorite> { seal in
      let entity = NSEntityDescription.entity(forEntityName: "FavoriteEntity", in: coreDataStorage.context)
      if let entity = entity {
        let managedObject = NSManagedObject(entity: entity, insertInto: coreDataStorage.context)
        let id = newFavoriteId
        managedObject.setValue(favorite.boardId, forKey: "boardId")
        managedObject.setValue(favorite.boardTitle, forKey: "boardTitle")
        managedObject.setValue(id, forKey: "id")
        do {
          try coreDataStorage.context.save()
          seal.fulfill(favorite)
        } catch {
          seal.reject(CoreDataError.saveError)
        }
      } else {
        seal.reject(CoreDataError.saveError)
      }
    }
  }
  
  public func delete(_ favorite: Favorite) -> Promise<Void> {
    return Promise<Void> { seal in
      guard let id = favorite.id else {
        print("\(Self.self) delete(_:) - favorite id is nil.")
        seal.reject(CoreDataError.deleteError)
        return
      }
      do {
        let fetchRequest = FavoriteEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %i", id)
        if let fetchResult = try coreDataStorage.context.fetch(fetchRequest).first {
          coreDataStorage.context.delete(fetchResult)
          coreDataStorage.saveContext()
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
      let request: NSFetchRequest<NSFetchRequestResult> = FavoriteEntity.fetchRequest()
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
