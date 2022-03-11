//
//  NetworkError.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/02/21.
//

import Foundation

public enum NetworkError: Error {
  case unknown
  case urlParseError
  case invalidCode(code: Int)
  case decodeError
  case encodeError
}
