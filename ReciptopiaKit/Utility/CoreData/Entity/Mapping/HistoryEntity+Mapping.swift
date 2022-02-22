//
//  HistoryEntity+Mapping.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/02/22.
//

import Foundation

extension HistoryEntity {
  func toDomain() -> History {
    return History(id: Int(id), ingredient: self.ingredient)
  }
}
