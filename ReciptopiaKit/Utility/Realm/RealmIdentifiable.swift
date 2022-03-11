//
//  RealmIdentifiable.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/03/04.
//

import Foundation
import Realm
import RealmSwift

protocol RealmIdentifiable: AnyObject {
  var id: Int { get set }
  func incrementId()
}

extension RealmIdentifiable where Self: Object {
  func incrementId() {
    let realm = RealmUtil.shared.realm
    self.id = (realm.objects(Self.self).max(ofProperty: "id") as Int? ?? 0) + 1
  }
}
