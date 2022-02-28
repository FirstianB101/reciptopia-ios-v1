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
  
  // MARK: - Properties
  private var bag = Set<AnyCancellable>()
  
  // MARK: - Methods
  public init(
    viewModel: SearchIngredientViewModel,
    searchHistoryRootView: SearchHistoryRootView
  ) {
    self.viewModel = viewModel
    self.searchHistoryRootView = searchHistoryRootView
    super.init()
    observeViewModel()
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    view = SearchIngredientRootView(
      viewModel: viewModel,
      searchHistoryRootView: searchHistoryRootView
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
          default: break
        }
      }.store(in: &bag)
  }
}
