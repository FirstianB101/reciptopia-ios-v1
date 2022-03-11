//
//  String+Date.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/03/12.
//

import Foundation

public extension Date {
  func toString(format: String) -> String {
    let formatter = DateFormatter()
    formatter.calendar = Calendar.current
    formatter.timeZone = TimeZone.current
    formatter.locale = Locale.current
    formatter.dateFormat = format
    return formatter.string(from: self)
  }
  
  func toString(dateFormat: DateFormat) -> String {
    switch dateFormat {
      case .iso8601:
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
      default:
        return toString(format: dateFormat.rawValue)
    }
  }
  
  static func timestamp() -> String {
    return Date().toString(dateFormat: .iso8601)
  }
}

public enum DateFormat: String {
  case iso8601
  case yearMonthDate = "YYYY년 M월 d일"
}
