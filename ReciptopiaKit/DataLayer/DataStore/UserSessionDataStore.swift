//
//  UserSessionDataStore.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/03/02.
//

import Foundation
import PromiseKit

public protocol UserSessionDataStore {
  func readUserSession() -> Promise<UserSession?>
  func saveUserSession(_ userSession: UserSession) -> Promise<UserSession>
  func deleteUserSession() -> Promise<Void>
}
