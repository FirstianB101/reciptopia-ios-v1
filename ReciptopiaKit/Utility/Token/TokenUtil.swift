//
//  TokenUtil.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/02/21.
//

import Foundation

public final class TokenUtil {
  
  // MARK: - Properties
  static let shared = TokenUtil()
  
  private var token: AuthToken?
  
  // MARK: - Methods
  public func readToken() -> AuthToken? {
    return token
  }
  
  public func registerToken(_ token: AuthToken) {
    self.token = token
  }
}
