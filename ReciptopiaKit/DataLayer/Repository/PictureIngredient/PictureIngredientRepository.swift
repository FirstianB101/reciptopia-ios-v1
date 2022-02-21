//
//  PictureIngredientRepository.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/02/21.
//

import Foundation
import PromiseKit

public protocol PictureIngredientRepository {
  func analyze(_ pictures: [Data]) -> Promise<[Ingredient]>
}
