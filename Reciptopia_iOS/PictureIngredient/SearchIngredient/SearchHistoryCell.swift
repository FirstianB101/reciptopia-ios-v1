//
//  SearchHistoryCell.swift
//  Reciptopia_iOS
//
//  Created by 김세영 on 2022/02/28.
//

import UIKit
import Reciptopia_UIKit
import SnapKit

class SearchHistoryCell: UITableViewCell {
  
  // MARK: - Properties
  static let reuseIdentifier = String(describing: SearchHistoryCell.self)
  
  lazy var contentStack: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [magnifyingglassImage, ingredientNameLabel])
    stack.axis = .horizontal
    stack.spacing = 10
    stack.alignment = .center
    stack.distribution = .fill
    return stack
  }()
  
  let magnifyingglassImage: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(systemName: "magnifyingglass.circle.fill")
    imageView.tintColor = .searchHistoryTint
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
    return imageView
  }()
  
  let ingredientNameLabel: UILabel = {
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
  
  public func configureCell(_ ingredients: [String]) {
    ingredientNameLabel.text = ingredients.joined(separator: ", ")
  }
}
