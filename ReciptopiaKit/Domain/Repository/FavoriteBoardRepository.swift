//
//  FavoriteBoardRepository.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/02/28.
//

import Foundation
import PromiseKit

public protocol FavoriteBoardRepository {
  func fetch(_ page: Int) -> Promise<[Favorite]>
  func save(_ favorite: Favorite) -> Promise<Favorite>
  func delete(_ favorite: Favorite) -> Promise<Void>
}
