//
//  UIButtonExtension.swift
//  Reciptopia_UIKit
//
//  Created by 김세영 on 2022/02/22.
//

import UIKit

extension UIButton {
  
  public func setTitleFont(_ font: UIFont) {
    self.titleLabel?.font = font
  }
  
  public var titleForNormal: String? {
    get { self.title(for: .normal) }
    set { self.setTitle(newValue, for: .normal) }
  }
  
  public var isEnabledWithAlpha: Bool {
    get { self.isEnabled }
    set {
      self.isEnabled = newValue
      self.backgroundColor = self.backgroundColor?.withAlphaComponent(isEnabled ? 1 : 0.5)
    }
  }
}
