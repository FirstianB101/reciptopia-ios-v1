//
//  SearchHistoryRootView.swift
//  Reciptopia_iOS
//
//  Created by 김세영 on 2022/02/28.
//

import Foundation
import Reciptopia_UIKit
import ReciptopiaKit
import SnapKit
import Combine

public final class SearchHistoryRootView: NiblessView {
  
  // MARK: - Properties
  lazy var historyTableView: UITableView = {
    let tableView = UITableView()
    tableView.register(
      SearchHistoryCell.self,
      forCellReuseIdentifier: SearchHistoryCell.reuseIdentifier
    )
    tableView.keyboardDismissMode = .onDrag
    tableView.delegate = self
    tableView.dataSource = self
    return tableView
  }()
  
  let viewModel: SearchHistoryViewModel
  var bag = Set<AnyCancellable>()
  
  // MARK: - Methods
  public init(frame: CGRect = .zero, viewModel: SearchHistoryViewModel) {
    self.viewModel = viewModel
    super.init(frame: frame)
    observeViewModel()
  }
  
  public override func didMoveToWindow() {
    super.didMoveToWindow()
    addSubview(historyTableView)
    historyTableView.snp.makeConstraints { make in
      make.top.leading.bottom.trailing.equalToSuperview()
    }
  }
  
  private func observeViewModel() {
    viewModel.reloadTrigger
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.historyTableView.reloadData()
      }.store(in: &bag)
  }
}

extension SearchHistoryRootView: UITableViewDelegate, UITableViewDataSource {
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.searchHistories.count
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: SearchHistoryCell.reuseIdentifier,
      for: indexPath
    ) as? SearchHistoryCell else { return UITableViewCell() }
    
    let ingredients = viewModel.searchHistories[indexPath.row].ingredients
    cell.configureCell(ingredients)
    
    return cell
  }
  
  public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let action = UIContextualAction(style: .destructive, title: "삭제") { [weak self] _, _, completionHandler in
      guard let strongSelf = self else { return }
      strongSelf.viewModel.deleteHistory(at: indexPath.row) {
        tableView.deleteRows(at: [indexPath], with: .bottom)
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        completionHandler(true)
      }
    }
    let configuration = UISwipeActionsConfiguration(actions: [action])
    return configuration
  }
  
  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
  
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print(indexPath.row)
  }
}
