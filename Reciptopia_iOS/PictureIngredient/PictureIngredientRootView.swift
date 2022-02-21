//
//  PictureIngredientRootView.swift
//  Reciptopia_iOS
//
//  Created by 김세영 on 2022/02/21.
//

import Foundation
import Reciptopia_UIKit
import ReciptopiaKit

public class PictureIngredientRootView: NiblessView {
  
  // MARK: - Dependencies
  let viewModel: PictureIngredientViewModel
  
  // MARK: - Properties
  
  
  // MARK: - Methods
  init(frame: CGRect = .zero, viewModel: PictureIngredientViewModel) {
    self.viewModel = viewModel
    super.init(frame: frame)
  }
}
