//
//  NiblessViewController.swift
//  Reciptopia_UIKit
//
//  Created by 김세영 on 2022/02/21.
//

import UIKit

open class NiblessViewController: UIViewController {
  
  @available(*, unavailable, message: "init(nibName:bundle:) is called.")
  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    fatalError("init(nibName:bundle:) is called.")
  }
  
  @available(*, unavailable, message: "init?(coder:) is called.")
  public required init?(coder: NSCoder) {
    fatalError("init?(coder:) is called.")
  }
  
  public init() {
    super.init(nibName: nil, bundle: nil)
  }
}
