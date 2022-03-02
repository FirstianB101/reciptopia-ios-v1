//
//  AuthRemoteAPI.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/03/02.
//

import Foundation
import PromiseKit

public protocol AuthRemoteAPI {
  func signIn(email: String, password: String) -> Promise<UserSession>
  func signUp(newAccount: Account) -> Promise<UserSession>
}
