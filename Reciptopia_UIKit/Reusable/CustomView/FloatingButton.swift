//
//  FloatingButton.swift
//  Reciptopia_UIKit
//
//  Created by 김세영 on 2022/02/28.
//

import UIKit

open class FloatingButton: UIButton {
  
  // MARK: - Properties
  var iconImageView: UIImageView = UIImageView()
  let size: CGFloat
  var originY: CGFloat = CGFloat()
  var isKeyboardAppear: Bool = false
  
  // MARK: - Methods
  public init(size: Int) {
    self.size = CGFloat(size)
    super.init(frame: .zero)
    styleView()
    observeKeyboard()
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  private func styleView() {
    iconImageView.tintColor = .white
    backgroundColor = .accentColor
    
    heightAnchor.constraint(equalToConstant: size).isActive = true
    widthAnchor.constraint(equalToConstant: size).isActive = true
  }
  
  private func observeKeyboard() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow(_:)),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide(_:)),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
  }
  
  open override func didMoveToWindow() {
    super.didMoveToWindow()
    setCircle()
    setIconImage()
    setShadow()
  }
  
  private func setCircle() {
    layer.cornerRadius = size / 2
  }
  
  private func setIconImage() {
    addSubview(iconImageView)
    iconImageView.preferredSymbolConfiguration = .init(font: .systemFont(ofSize: size / 2))
    iconImageView.translatesAutoresizingMaskIntoConstraints = false
    iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
  }
  
  private func setShadow() {
    layer.shadowColor = UIColor.lightGray.cgColor
    layer.shadowOffset = CGSize(width: 1, height: 1)
    layer.shadowOpacity = 1
  }
  
  @objc private func keyboardWillShow(_ notification: Notification) {
    if isKeyboardAppear { return }
    isKeyboardAppear = true
    guard let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
                                as? NSValue)?.cgRectValue.size.height else { return }
    originY = self.frame.minY
    print("keyboard shown")
    UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions(), animations: {
      self.frame = CGRect(
        x: self.frame.minX,
        y: self.frame.minY - keyboardHeight,
        width: self.frame.width,
        height: self.frame.height
      )
    }, completion: nil)
  }
  
  @objc private func keyboardWillHide(_ notification: Notification) {
    isKeyboardAppear = false
    print("keyboard hidden")
    UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions(), animations: {
      self.frame = CGRect(
        x: self.frame.minX,
        y: self.originY,
        width: self.frame.width,
        height: self.frame.height
      )
    }, completion: nil)
  }
  
  // MARK: - Public Methods
  public func setImage(_ image: UIImage?) {
    iconImageView.image = image
  }
}
