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
  
  // MARK: - Methods
  public func readToken() -> AuthToken? {
    return "token"
  }
}
