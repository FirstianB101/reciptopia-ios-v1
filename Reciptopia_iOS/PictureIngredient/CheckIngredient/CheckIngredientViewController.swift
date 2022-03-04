//
//  CheckIngredientViewController.swift
//  Reciptopia_iOS
//
//  Created by 김세영 on 2022/03/01.
//

import Foundation
import Reciptopia_UIKit
import ReciptopiaKit
import Combine

public class CheckIngredientViewController: NiblessViewController {
  
  // MARK: - Dependencies
  let viewModel: SearchIngredientViewModel
  let searchIngredientViewController: SearchIngredientViewController
  
  // MARK: - Properties
  var bag = Set<AnyCancellable>()
  
  // MARK: - Methods
  public init(
    viewModel: SearchIngredientViewModel,
    searchIngredientViewController: SearchIngredientViewController
  ) {
    self.viewModel = viewModel
    self.searchIngredientViewController = searchIngredientViewController
    super.init()
    observeViewModel()
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    view = CheckIngredientRootView(viewModel: viewModel)
  }
  
  private func observeViewModel() {
    viewModel.action
      .receive(on: DispatchQueue.main)
      .sink { [weak self] action in
        switch action {
          case .presentBoardList(let boards): self?.presentBoards(boards)
          case .dismiss: self?.dismiss(animated: true)
        }
      }.store(in: &bag)
  }
  
  private func presentBoards(_ boards: [Board]) {
    let presentingViewController = self.presentingViewController
    dismiss(animated: true) { [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.searchIngredientViewController.modalTransitionStyle = .crossDissolve
      strongSelf.searchIngredientViewController.modalPresentationStyle = .fullScreen
      presentingViewController?.present(strongSelf.searchIngredientViewController, animated: false) {
        strongSelf.searchIngredientViewController.presentBoards(boards)
      }
    }
  }
}
