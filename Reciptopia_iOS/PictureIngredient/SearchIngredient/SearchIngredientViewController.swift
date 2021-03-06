//
//  SearchIngredientViewController.swift
//  Reciptopia_iOS
//
//  Created by 김세영 on 2022/02/23.
//

import UIKit
import ReciptopiaKit
import Reciptopia_UIKit
import Combine

public class SearchIngredientViewController: NiblessViewController {
  
  // MARK: - Dependencies
  let viewModel: SearchIngredientViewModel
  let searchHistoryRootView: SearchHistoryRootView
  let favoriteBoardRootView: FavoriteBoardRootView
  
  // MARK: - Properties
  private var bag = Set<AnyCancellable>()
  
  // MARK: - Methods
  public init(
    viewModel: SearchIngredientViewModel,
    searchHistoryRootView: SearchHistoryRootView,
    favoriteBoardRootView: FavoriteBoardRootView
  ) {
    self.viewModel = viewModel
    self.searchHistoryRootView = searchHistoryRootView
    self.favoriteBoardRootView = favoriteBoardRootView
    super.init()
    observeViewModel()
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    view = SearchIngredientRootView(
      viewModel: viewModel,
      searchHistoryRootView: searchHistoryRootView,
      favoriteBoardRootView: favoriteBoardRootView
    )
  }
  
  private func observeViewModel() {
    observeAlert()
    observeAction()
  }
  
  private func observeAlert() {
    viewModel.alertPublisher
      .sink(receiveValue: presentAlert(_:))
      .store(in: &bag)
  }
  
  private func observeAction() {
    viewModel.action
      .sink { [weak self] action in
        switch action {
          case .dismiss: self?.dismiss(animated: true)
          case .presentBoardList(let boards): self?.presentBoards(boards)
        }
      }.store(in: &bag)
  }
  
  public func presentBoards(_ boards: [Board]) {
    let vc = BoardListViewController()
    vc.modalTransitionStyle = .crossDissolve
    present(vc, animated: true)
  }
}
