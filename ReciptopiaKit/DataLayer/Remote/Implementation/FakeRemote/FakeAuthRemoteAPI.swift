//
//  FakeAuthRemoteAPI.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/03/02.
//

import Foundation
import PromiseKit

public final class FakeAuthRemoteAPI: AuthRemoteAPI {
  
  // MARK: - Properties
  let mockUserSession: UserSession
  
  // MARK: - Methods
  public init() {
    let mockAccount = Account(
      email: "yy0867@gmail.com",
      password: "12345678",
      nickname: "Harry",
      profilePictureURL: URL(string: "https://shorturl.at/xyGHM")!
    )
    
    self.mockUserSession = UserSession(token: "token", account: mockAccount)
  }
  
  public func signIn(email: String, password: String) -> Promise<UserSession> {
    return Promise.value(mockUserSession)
  }
  
  public func signUp(newAccount: Account) -> Promise<UserSession> {
    return Promise.value(mockUserSession)
  }
}
