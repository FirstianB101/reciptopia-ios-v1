//
//  FavoriteBoardRootView.swift
//  Reciptopia_iOS
//
//  Created by 김세영 on 2022/02/28.
//

import Foundation
import Combine
import Reciptopia_UIKit
import ReciptopiaKit
import SnapKit

public final class FavoriteBoardRootView: NiblessView {
  
  // MARK: - Properties
  lazy var favoriteTableView: UITableView = {
    let tableView = UITableView()
    tableView.register(
      FavoriteBoardCell.self,
      forCellReuseIdentifier: FavoriteBoardCell.reuseIdentifier
    )
    tableView.keyboardDismissMode = .onDrag
    tableView.delegate = self
    tableView.dataSource = self
    return tableView
  }()
  
  let viewModel: FavoriteBoardViewModel
  var bag = Set<AnyCancellable>()
  
  // MARK: - Methods
  public init(frame: CGRect = .zero, viewModel: FavoriteBoardViewModel) {
    self.viewModel = viewModel
    super.init(frame: frame)
  }
  
  public override func didMoveToWindow() {
    super.didMoveToWindow()
    addSubview(favoriteTableView)
    favoriteTableView.snp.makeConstraints { make in
      make.top.leading.bottom.trailing.equalToSuperview()
    }
  }
}

extension FavoriteBoardRootView: UITableViewDelegate, UITableViewDataSource {
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.favorites.count
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: FavoriteBoardCell.reuseIdentifier,
      for: indexPath
    ) as? FavoriteBoardCell else { return UITableViewCell() }
    
    let favorite = viewModel.favorites[indexPath.row]
    cell.configureCell(favorite.boardTitle)
    
    return cell
  }
  
  public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let action = UIContextualAction(style: .destructive, title: "삭제") { [weak self] _, _, completionHandler in
      guard let strongSelf = self else { return }
      strongSelf.viewModel.deleteFavorite(at: indexPath.row) {
        tableView.deleteRows(at: [indexPath], with: .fade)
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
    
  }
}
