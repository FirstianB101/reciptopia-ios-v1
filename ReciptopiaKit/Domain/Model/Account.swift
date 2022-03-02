//
//  Account.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/03/02.
//

import Foundation

public struct Account: Codable {
  public let email: String
  public let password: String
  public let nickname: String
  public let profilePictureURL: URL
}
