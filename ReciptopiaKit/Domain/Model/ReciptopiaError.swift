//
//  ReciptopiaError.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/03/02.
//

import Foundation

public enum ReciptopiaError: Error {
  case unknown
  case decodeError
  case encodeError
  case accountNotFound
}
