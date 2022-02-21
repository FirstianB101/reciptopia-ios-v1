//
//  PictureIngredientViewController.swift
//  Reciptopia_iOS
//
//  Created by 김세영 on 2022/02/21.
//

import UIKit
import ReciptopiaKit
import Reciptopia_UIKit

public class PictureIngredientViewController: NiblessViewController {
  
  // MARK: - Properties
  let viewModel: PictureIngredientViewModel
  
  // MARK: - Methods
  public init(viewModel: PictureIngredientViewModel) {
    self.viewModel = viewModel
    super.init()
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    view = PictureIngredientRootView(viewModel: viewModel)
  }
}
