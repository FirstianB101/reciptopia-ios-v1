//
//  FakeSearchBoardByIngredientRepository.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/03/03.
//

import Foundation
import PromiseKit

public final class FakeSearchBoardByIngredientRepository: SearchBoardByIngredientRepository {
  
  // MARK: - Mocks
  let mockAccount = Account(
    email: "yy0867@gmail.com",
    password: "12345678",
    nickname: "Harry",
    profilePictureURL: URL(string: "https://shorturl.at/xyGHM")!
  )
  
  let mockPictureURLs = [URL](repeating: URL(string: "https://picsum.photos/200")! , count: 10)
  
  // MARK: - Methods
  public init() {}
  
  public func searchBoards(by ingredients: [Ingredient]) -> Promise<[Board]> {
    var boards = [Board]()
    for i in 1...10 {
      boards.append(
        .init(
          id: 1,
          owner: mockAccount,
          pictureURLs: mockPictureURLs,
          title: "Board \(i)",
          content: "Content of Board \(i), Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ac placerat metus, interdum maximus eros. Nunc tempus tortor scelerisque erat dapibus mattis. Maecenas pulvinar, leo sit amet cursus semper, augue metus porttitor massa, in feugiat dui urna et eros. Donec quis odio nulla. Morbi sed fermentum magna.",
          views: 120,
          numberOfComment: 30,
          numberOfLikeTag: 20
        )
      )
    }
    
    return Promise.value(boards)
  }
}
