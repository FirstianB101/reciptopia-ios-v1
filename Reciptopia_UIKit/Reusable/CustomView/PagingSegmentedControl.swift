//
//  PagingSegmentedControl.swift
//  Reciptopia_UIKit
//
//  Created by 김세영 on 2022/02/28.
//

import UIKit

open class PagingSegmentedControl: UISegmentedControl {
  
  // MARK: - Properties
  
  // MARK: - Methods
  public init() {
    super.init(frame: .zero)
    styleView()
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func styleView() {
    let normalAttribute: [NSAttributedString.Key : Any] = [
      .font : UIFont.systemFont(ofSize: 13),
      .foregroundColor : UIColor.lightGray
    ]
    let selectedAttribute: [NSAttributedString.Key: Any] = [
      .font: UIFont.boldSystemFont(ofSize: 15),
      .foregroundColor: UIColor.black
    ]
    self.setTitleTextAttributes(normalAttribute, for: .normal)
    self.setTitleTextAttributes(selectedAttribute, for: .selected)
    self.selectedSegmentIndex = 0
    self.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
    self.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    self.layer.borderColor = UIColor.lightGray.cgColor
    self.layer.borderWidth = 0.2
  }
}
