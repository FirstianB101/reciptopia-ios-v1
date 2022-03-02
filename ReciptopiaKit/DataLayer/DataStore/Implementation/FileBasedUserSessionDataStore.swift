//
//  FileBasedUserSessionDataStore.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/03/02.
//

import Foundation
import PromiseKit

public final class FileBasedUserSessionDataStore: UserSessionDataStore {
  
  // MARK: - Properties
  private let fileName = "UserSession.json"
  private var defaultURL: URL? {
    return FileManager.default
      .urls(for: FileManager.SearchPathDirectory.documentDirectory,
               in: FileManager.SearchPathDomainMask.allDomainsMask).first
  }
  
  // MARK: - Methods
  public init() {}
  
  /// Always return nil.
  public func readUserSession() -> Promise<UserSession?> {
    return Promise<UserSession?> { seal in
      guard let fileURL = defaultURL else {
        seal.reject(ReciptopiaError.unknown)
        return
      }
      guard let jsonUserSession = try? Data(contentsOf: fileURL.appendingPathComponent(fileName)) else {
        seal.fulfill(nil)
        return
      }
      guard let userSession = try? JSONDecoder().decode(UserSession.self, from: jsonUserSession) else {
        seal.reject(ReciptopiaError.decodeError)
        return
      }
      seal.fulfill(userSession)
    }
  }
  
  public func saveUserSession(_ userSession: UserSession) -> Promise<UserSession> {
    return Promise<UserSession> { seal in
      guard let fileURL = defaultURL else {
        seal.reject(ReciptopiaError.unknown)
        return
      }
      guard let jsonUserSession = try? JSONEncoder().encode(userSession) else {
        seal.reject(ReciptopiaError.unknown)
        return
      }
      try? jsonUserSession.write(to: fileURL.appendingPathComponent(fileName))
      seal.fulfill(userSession)
    }
  }
  
  public func deleteUserSession() -> Promise<Void> {
    return Promise<Void> { seal in
      guard let fileURL = defaultURL else {
        seal.reject(ReciptopiaError.unknown)
        return
      }
      do {
        try FileManager.default.removeItem(at: fileURL.appendingPathComponent(fileName))
      } catch {
        seal.reject(ReciptopiaError.unknown)
        return
      }
      seal.fulfill(())
    }
  }
}
