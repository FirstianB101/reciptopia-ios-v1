//
//  SearchHistoryRepository.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/02/22.
//

import Foundation
import PromiseKit

public protocol SearchHistoryRepository {
  func fetch(_ page: Int) -> Promise<[History]>
  func save(_ history: History) -> Promise<History>
  func delete(_ history: History) -> Promise<Void>
  func deleteAll() -> Promise<Void>
}
