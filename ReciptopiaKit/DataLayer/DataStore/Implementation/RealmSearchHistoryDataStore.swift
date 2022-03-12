//
//  RealmHistoryDataStore.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/03/12.
//

import Foundation
import PromiseKit

public final class RealmSearchHistoryDataStore: SearchHistoryDataStore {
  
  public init() {}
  
  public func fetch(_ page: Int) -> Promise<[History]> {
    return RealmUtil.shared.read(objectType: HistoryRealmEntity.self)
      .then(sortByTimestamp(_:))
      .then(toDomain(_:))
  }
  
  private func sortByTimestamp(_ entities: [HistoryRealmEntity]) -> Promise<[HistoryRealmEntity]> {
    let sortedEntities = entities.sorted { $0.timestamp < $1.timestamp }
    return Promise<[HistoryRealmEntity]>.value(sortedEntities)
  }
  
  public func save(_ history: History) -> Promise<History> {
    return RealmUtil.shared.create(history.toRealmEntity())
      .then(toDomain(_:))
  }
  
  public func update(_ history: History) -> Promise<Void> {
    guard let id = history.id else { return Promise(error: ReciptopiaError.updateError) }
    return RealmUtil.shared.update(id: id, forType: HistoryRealmEntity.self) { entity in
      entity.timestamp = history.timestamp
    }
  }
  
  public func delete(_ history: History) -> Promise<Void> {
    guard let id = history.id else { return Promise(error: ReciptopiaError.deleteError) }
    return RealmUtil.shared.delete(id: id, ofType: HistoryRealmEntity.self)
  }
  
  public func deleteAll() -> Promise<Void> {
    return RealmUtil.shared.deleteAll(ofType: HistoryRealmEntity.self)
  }
  
  private func toDomain(_ entity: HistoryRealmEntity) -> Promise<History> {
    let history = entity.toDomain()
    return Promise<History>.value(history)
  }
  
  private func toDomain(_ entities: [HistoryRealmEntity]) -> Promise<[History]> {
    let histories = entities.map { $0.toDomain() }
    return Promise<[History]>.value(histories)
  }
}
