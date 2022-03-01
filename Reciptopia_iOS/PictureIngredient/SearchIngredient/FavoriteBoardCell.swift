//
//  FavoriteBoardCell.swift
//  Reciptopia_iOS
//
//  Created by 김세영 on 2022/02/28.
//

import Foundation
import UIKit
import SnapKit

internal class FavoriteBoardCell: UITableViewCell {
  
  // MARK: - Properties
  static let reuseIdentifier = String(describing: FavoriteBoardCell.self)
  
  lazy var contentStack: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [starImage, boardTitleLabel])
    stack.axis = .horizontal
    stack.spacing = 10
    stack.alignment = .center
    stack.distribution = .fill
    return stack
  }()
  
  let starImage: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(systemName: "star.fill")
    imageView.tintColor = .favoriteStarTint
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
    return imageView
  }()
  
  let boardTitleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.font = .systemFont(ofSize: 16)
    return label
  }()
  
  // MARK: - Methods
  override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .none
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func didMoveToWindow() {
    super.didMoveToWindow()
    
    addSubview(contentStack)
    contentStack.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.trailing.equalToSuperview().inset(20)
    }
  }
  
  public func configureCell(_ boardTitle: String) {
    boardTitleLabel.text = boardTitle
  }
}
