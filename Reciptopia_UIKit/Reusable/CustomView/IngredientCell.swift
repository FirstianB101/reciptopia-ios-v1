//
//  IngredientCell.swift
//  Reciptopia_UIKit
//
//  Created by 김세영 on 2022/02/26.
//

import UIKit

open class IngredientCell: UICollectionViewCell {
  
  public enum State {
    case selected, deselected
  }
  
  // MARK: - Properties
  public lazy var contentStack: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [nameLabel, removeButton])
    stack.axis = .horizontal
    stack.distribution = .fill
    stack.spacing = 5
    stack.alignment = .center
    return stack
  }()
  
  let nameLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = .systemFont(ofSize: 14)
    return label
  }()
  
  let removeButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "xmark"), for: .normal)
    button.tintColor = .white
    button.widthAnchor.constraint(equalToConstant: 12).isActive = true
    button.heightAnchor.constraint(equalToConstant: 12).isActive = true
    return button
  }()
  
  private var _toggleState: State = .deselected
  private var toggleState: State {
    get { _toggleState }
    set {
      _toggleState = newValue
      switch _toggleState {
        case .selected: self.backgroundColor = selectedColor
        case .deselected: self.backgroundColor = deselectedColor
      }
    }
  }
  private var selectedColor: UIColor = .mainIngredient
  private var deselectedColor: UIColor = .accentColor
  
  public var removeHandler: () -> Void = {}
  public static let reuseIdentifier = String(describing: IngredientCell.self)
  
  // MARK: - Methods
  public override init(frame: CGRect) {
    super.init(frame: frame)
    styleCell()
    removeButton.addTarget(self, action: #selector(removeButtonClicked), for: .touchUpInside)
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  open override func didMoveToWindow() {
    super.didMoveToWindow()
    addSubview(contentStack)
    contentStack.translatesAutoresizingMaskIntoConstraints = false
    contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14).isActive = true
    contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14).isActive = true
    contentStack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
  }
  
  open override func layoutSubviews() {
    super.layoutSubviews()
    self.layer.cornerRadius = self.bounds.height / 2
  }
  
  private func styleCell() {
    self.backgroundColor = deselectedColor
    let heightAnchor = heightAnchor.constraint(equalToConstant: 30)
    heightAnchor.priority = .init(rawValue: 750)
    heightAnchor.isActive = true
  }
  
  private func changeState(to state: State) {
    toggleState = state
  }
  
  private func setTitle(_ title: String) {
    nameLabel.text = title
  }
  
  public func configureCell(name: String, isMainIngredient: Bool) {
    setTitle(name)
    changeState(to: isMainIngredient ? .selected : .deselected)
  }
  
  @objc private func removeButtonClicked() {
    removeHandler()
  }
}
