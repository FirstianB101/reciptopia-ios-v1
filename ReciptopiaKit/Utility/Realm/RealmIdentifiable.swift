//
//  RealmIdentifiable.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/03/04.
//

import Foundation
import Realm
import RealmSwift

protocol RealmIdentifiable {
  var id: Int { get set }
  func incrementId()
}
