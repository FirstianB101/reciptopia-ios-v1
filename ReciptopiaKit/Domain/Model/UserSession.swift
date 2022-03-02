//
//  UserSession.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/02/22.
//

import Foundation

public final class UserSession: Codable {
  public let token: AuthToken
  public let account: Account
  
  public init(token: AuthToken, account: Account) {
    self.token = token
    self.account = account
  }
}
