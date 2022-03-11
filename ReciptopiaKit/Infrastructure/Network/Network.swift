//
//  Network.swift
//  Reciptopia_iOS
//
//  Created by 김세영 on 2022/02/21.
//

import Foundation
import PromiseKit

public final class NetworkSession {
  
  // MARK: - Properties
  static let shared = NetworkSession()
  
  // MARK: - Methods
  private func request(_ urlRequest: URLRequest) -> Promise<Data> {
    return Promise<Data> { seal in
      URLSession.shared.dataTask(with: urlRequest) { data, response, error in
        if let error = error {
          seal.reject(error)
          return
        }
        guard let response = response as? HTTPURLResponse else {
          seal.reject(NetworkError.unknown)
          return
        }
        guard 200..<300 ~= response.statusCode else {
          seal.reject(NetworkError.invalidCode(code: response.statusCode))
          return
        }
        guard let data = data else {
          seal.reject(NetworkError.unknown)
          return
        }
        seal.fulfill(data)
      }.resume()
    }
  }
  
  private func addHeaders(in url: URL) -> URLRequest {
    var urlRequest = URLRequest(url: url)
    urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
    if let token = TokenUtil.shared.readToken() {
      urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
    return urlRequest
  }
  
  public func get<T>(url: String, to type: T.Type) -> Promise<T> where T: Decodable {
    guard let url = URL(string: url) else {
      return Promise(error: NetworkError.urlParseError)
    }
    var urlRequest = addHeaders(in: url)
    urlRequest.httpMethod = "GET"
    
    return request(urlRequest).then(decode(_:))
  }
  
  public func post<T>(url: String, parameter: Encodable, to type: T.Type) -> Promise<T> where T: Decodable {
    guard let url = URL(string: url) else {
      return Promise(error: NetworkError.urlParseError)
    }
    var urlRequest = addHeaders(in: url)
    urlRequest.httpMethod = "POST"
    urlRequest.httpBody = parameter.toData()
    
    return request(urlRequest).then(decode(_:))
  }
  
  public func patch<T>(url: String, parameter: Encodable, to type: T.Type) -> Promise<T> where T: Decodable {
    guard let url = URL(string: url) else {
      return Promise(error: NetworkError.urlParseError)
    }
    var urlRequest = addHeaders(in: url)
    urlRequest.httpMethod = "PATCH"
    urlRequest.httpBody = parameter.toData()
    
    return request(urlRequest).then(decode(_:))
  }
  
  public func delete(url: String) -> Promise<Void> {
    guard let url = URL(string: url) else {
      return Promise(error: NetworkError.urlParseError)
    }
    var urlRequest = addHeaders(in: url)
    urlRequest.httpMethod = "DELETE"
    
    return request(urlRequest).asVoid()
  }
}

fileprivate extension NetworkSession {
  func decode<T>(_ data: Data) -> Promise<T> where T: Decodable {
    guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
      return Promise(error: NetworkError.decodeError)
    }
    return Promise.value(decodedData)
  }
}

fileprivate extension Encodable {
  func toData() -> Data? {
    return try? JSONEncoder().encode(self)
  }
}
