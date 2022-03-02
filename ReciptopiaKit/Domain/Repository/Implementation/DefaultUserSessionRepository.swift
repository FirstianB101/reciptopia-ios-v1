//
//  DefaultUserSessionRepository.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/03/02.
//

import Foundation
import PromiseKit

public final class DefaultUserSessionRepository: UserSessionRepository {
  
  // MARK: - Properties
  let userSessionDataStore: UserSessionDataStore
  let authRemoteAPI: AuthRemoteAPI
  
  // MARK: - Methods
  public init(userSessionDataStore: UserSessionDataStore, authRemoteAPI: AuthRemoteAPI) {
    self.userSessionDataStore = userSessionDataStore
    self.authRemoteAPI = authRemoteAPI
  }
  
  public func readUserSession() -> Promise<UserSession?> {
    return userSessionDataStore.readUserSession()
      .then(saveToken(_:))
  }
  
  private func saveToken(_ userSession: UserSession?) -> Promise<UserSession?> {
    guard let userSession = userSession else { return Promise.value(nil) }
    TokenUtil.shared.registerToken(userSession.token)
    return Promise.value(userSession)
  }
  
  public func signIn(email: String, password: String) -> Promise<UserSession> {
    return authRemoteAPI.signIn(email: email, password: password)
      .then(userSessionDataStore.saveUserSession(_:))
      .then(saveToken(_:))
      .then { userSession -> Promise<UserSession> in
        guard let userSession = userSession else {
          return Promise(error: ReciptopiaError.accountNotFound)
        }
        return Promise.value(userSession)
      }
  }
  
  public func signUp(newAccount: Account) -> Promise<UserSession> {
    return authRemoteAPI.signUp(newAccount: newAccount)
      .then { [weak self] _ -> Promise<UserSession> in
        guard let strongSelf = self else { return Promise(error: ReciptopiaError.unknown) }
        return strongSelf.signIn(email: newAccount.email, password: newAccount.password)
      }
  }
}
