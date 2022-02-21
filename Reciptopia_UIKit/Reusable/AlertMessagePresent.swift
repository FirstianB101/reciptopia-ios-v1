//
//  AlertMessagePresent.swift
//  Reciptopia_UIKit
//
//  Created by 김세영 on 2022/02/21.
//

import UIKit
import ReciptopiaKit

extension UIViewController {
  public func presentAlert(_ alertMessage: AlertMessage) {
    let alertController = UIAlertController(
      title: alertMessage.title,
      message: alertMessage.message,
      preferredStyle: .alert
    )
    alertController.addAction(UIAlertAction(title: "확인", style: .default))
    present(alertController, animated: true)
  }
}
