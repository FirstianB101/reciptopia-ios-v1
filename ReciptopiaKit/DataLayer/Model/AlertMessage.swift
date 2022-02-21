//
//  AlertMessage.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/02/21.
//

import Foundation

public struct AlertMessage {
  public let id = UUID().uuidString
  public let title: String?
  public let message: String?
  
  public init(title: String?, message: String?) {
    self.title = title
    self.message = message
  }
  
  public static func makeErrorMessage() -> AlertMessage {
    return AlertMessage(title: "알림", message: "오류가 발생했습니다. 잠시 후 다시 시도해주세요.")
  }
}
