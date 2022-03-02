//
//  UserSessionRepository.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/03/02.
//

import Foundation
import PromiseKit

public protocol UserSessionRepository {
  func readUserSession() -> Promise<UserSession?>
  func signIn(email: String, password: String) -> Promise<UserSession>
  func signUp(newAccount: Account) -> Promise<UserSession>
}
