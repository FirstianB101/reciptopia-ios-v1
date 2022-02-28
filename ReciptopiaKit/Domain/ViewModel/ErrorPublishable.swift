//
//  ErrorPublishable.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/02/28.
//

import Combine

public protocol ErrorPublishable {
  var alertPublisher: PassthroughSubject<AlertMessage, Never> { get }
  func publishError(_ error: Error)
}

extension ErrorPublishable {
  public func publishError(_ error: Error) {
    alertPublisher.send(.makeErrorMessage())
  }
}
