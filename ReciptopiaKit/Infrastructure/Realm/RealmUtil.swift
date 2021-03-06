//
//  RealmUtil.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/03/04.
//

import Foundation
import Realm
import RealmSwift
import PromiseKit

final class RealmUtil {
  
  static let shared = RealmUtil()
  private let localRealm: Realm
  
  private init() {
    self.localRealm = try! Realm()
  }
  
  var realm: Realm { localRealm }
  
  func create<T>(_ realmObject: T) -> Promise<T> where T: Object {
    return Promise<T> { seal in
      do {
        try realm.write {
          realm.add(realmObject)
          seal.fulfill(realmObject)
        }
      } catch {
        seal.reject(ReciptopiaError.createError)
      }
    }
  }
  
  func read<T>(objectType: T.Type) -> Promise<[T]> where T: Object {
    return Promise<[T]> { seal in
      let objects = realm.objects(T.self)
      seal.fulfill(Array(objects))
    }
  }
  
  func query<T>(objectType: T.Type, forQuery query: (Query<T>) -> Query<Bool>) -> Promise<[T]> where T: Object {
    return Promise<[T]> { seal in
      let objects = realm.objects(objectType.self)
      let objectsForQuery = objects.where(query)
      seal.fulfill(Array(objectsForQuery))
    }
  }
  
  func update<T>(
    id: Int,
    forType type: T.Type,
    updateHandler: (T) -> Void
  ) -> Promise<Void> where T: RealmIdentifiable {
    return Promise<Void> { seal in
      guard let previousObject = realm.object(ofType: T.self, forPrimaryKey: id) else {
        seal.reject(ReciptopiaError.updateError)
        return
      }
      do {
        try realm.write {
          updateHandler(previousObject)
          seal.fulfill(())
        }
      } catch {
        seal.reject(ReciptopiaError.updateError)
      }
    }
  }
  
  func delete(id: Int, ofType type: RealmIdentifiable.Type) -> Promise<Void> {
    return Promise<Void> { seal in
      guard let object = realm.object(ofType: type.self, forPrimaryKey: id) else {
        seal.reject(ReciptopiaError.deleteError)
        return
      }
      do {
        try realm.write {
          realm.delete(object)
          seal.fulfill(())
        }
      } catch {
        seal.reject(ReciptopiaError.deleteError)
      }
    }
  }
  
  func deleteAll(ofType type: Object.Type) -> Promise<Void> {
    return Promise<Void> { seal in
      let objects = realm.objects(type.self)
      do {
        try realm.write {
          realm.delete(objects)
          seal.fulfill(())
        }
      } catch {
        seal.reject(ReciptopiaError.deleteError)
      }
    }
  }
}
