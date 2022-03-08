//
//  RealmUtil.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/03/04.
//

import Foundation
import Realm
import RealmSwift

final class RealmUtil {
  
  static let shared = RealmUtil()
  private let localRealm: Realm
  
  private init() {
    self.localRealm = try! Realm()
  }
  
  var realm: Realm { localRealm }
}
