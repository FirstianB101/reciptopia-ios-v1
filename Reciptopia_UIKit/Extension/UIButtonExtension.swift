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
}
