//
//  ManagePictureViewController.swift
//  Reciptopia_iOS
//
//  Created by 김세영 on 2022/02/22.
//

import Reciptopia_UIKit
import ReciptopiaKit
import Combine

public class ManagePictureViewController: NiblessViewController {
  
  // MARK: - Dependencies
  let viewModel: PictureIngredientViewModel
  
  // MARK: - Properties
  private var bag = Set<AnyCancellable>()
  
  lazy var deleteButton: UIBarButtonItem = {
    return UIBarButtonItem(
      barButtonSystemItem: .trash,
      target: viewModel,
      action: #selector(PictureIngredientViewModel.deleteIngredients)
    )
  }()
  
  // MARK: - Methods
  public init(viewModel: PictureIngredientViewModel) {
    self.viewModel = viewModel
    super.init()
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    view = ManagePictureRootView(viewModel: viewModel)
    configureNavigationBar()
  }
  
  private func configureNavigationBar() {
    navigationItem.setRightBarButton(deleteButton, animated: false)
  }
}
