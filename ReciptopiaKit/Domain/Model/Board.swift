//
//  Board.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/03/01.
//

import Foundation

public struct Board {
  public let id: Int?
  public let owner: Account
  public let pictureURLs: [URL]
  public let title: String
  public let content: String
  public let views: Int
  public let numberOfComment: Int
  public let numberOfLikeTag: Int
}
