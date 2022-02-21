//
//  NiblessView.swift
//  Reciptopia_UIKit
//
//  Created by 김세영 on 2022/02/21.
//

import UIKit

open class NiblessView: UIView {
  
  @available(*, unavailable, message: "init?(coder:) is called.")
  public required init?(coder: NSCoder) {
    fatalError("\(Self.self) init?(coder:) is called.")
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  open override func didMoveToWindow() {
    super.didMoveToWindow()
    backgroundColor = .white
  }
}
