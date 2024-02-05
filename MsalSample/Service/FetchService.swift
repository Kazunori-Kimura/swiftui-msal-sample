//
//  FetchService.swift
//  MsalSample
//
//  Created by Kazunori Kimura on 2024/02/05.
//

import Foundation
import Factory

protocol FetchServiceProtocol {
    func find<T>(path: String) async throws -> T where T: Decodable
    func find<T>(path: String, options: [String: String]) async throws -> T where T: Decodable
    func findMany<T>(path: String) async throws -> [T] where T: Decodable
    func findMany<T>(path: String, options: [String: String]) async throws -> [T] where T: Decodable
    func callAPI<T>(path: String, method: String) async throws -> T where T: Decodable
    func callAPI<T>(path: String, method: String, options: [String: String]) async throws -> T where T: Decodable
    func callAPI<T>(path: String, method: String, options: [String: String], body: Data?) async throws -> T where T: Decodable
}

/**
 * Fetch Service
 */
class FetchService: FetchServiceProtocol {
    @Injected(\.appContext)
    private var appContext
    
    private let apiBaseScheme: String
    private let apiBaseUrl: String
    
    init() {
        apiBaseScheme = Bundle.getBundleString(key: "API_SCHEME")
        apiBaseUrl = Bundle.getBundleString(key: "API_BASE_URL")
    }
    
    func find<T>(path: String) async throws -> T where T : Decodable {
        return try await self.find(path: path, options: [:])
    }
    
    func find<T>(path: String, options: [String : String]) async throws -> T where T : Decodable {
        let request = self.createURLRequest(method: "GET", path: path, options: options)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "FetchService", code: 500, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
        }
        
        if !httpResponse.ok {
            throw NSError(domain: "FetchService",
                          code: httpResponse.statusCode,
                          userInfo: [NSLocalizedDescriptionKey: httpResponse.status])
        }
        
        let decoder = JSONDecoder()
        let payload = try decoder.decode(T.self, from: data)
        
        return payload
    }
    
    func findMany<T>(path: String) async throws -> [T] where T : Decodable {
        return try await self.findMany(path: path, options: [:])
    }
    
    func findMany<T>(path: String, options: [String : String]) async throws -> [T] where T : Decodable {
        typealias Response = [T]
        
        let request = self.createURLRequest(method: "GET", path: path, options: options)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "FetchService", code: 500, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
        }
        
        if !httpResponse.ok {
            throw NSError(domain: "FetchService",
                          code: httpResponse.statusCode,
                          userInfo: [NSLocalizedDescriptionKey: httpResponse.status])
        }
        
        let decoder = JSONDecoder()
        let payload = try decoder.decode(Response.self, from: data)
        
        return payload
    }
    
    func callAPI<T>(path: String, method: String) async throws -> T where T : Decodable {
        return try await self.callAPI(path: path, method: method, options: [:], body: nil)
    }
    
    func callAPI<T>(path: String, method: String, options: [String : String]) async throws -> T where T : Decodable {
        return try await self.callAPI(path: path, method: method, options: options, body: nil)
    }
    
    func callAPI<T>(path: String, method: String, options: [String : String], body: Data?) async throws -> T where T : Decodable {
        var request = self.createURLRequest(method: method, path: path, options: options)
        request.httpBody = body
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "FetchService", code: 500, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
        }
        
        if !httpResponse.ok {
            throw NSError(domain: "FetchService",
                          code: httpResponse.statusCode,
                          userInfo: [NSLocalizedDescriptionKey: httpResponse.status])
        }
        
        if T.self == Void.self {
            return Void() as! T
        }

        // 型が Void でなければデコードする
        let decoder = JSONDecoder()
        let payload = try decoder.decode(T.self, from: data)
        
        return payload
    }
    
    private func createURLRequest(method: String, path: String, options: [String: String]) -> URLRequest {
        var urlComponent = URLComponents()
        urlComponent.scheme = apiBaseScheme
        urlComponent.host = apiBaseUrl
        urlComponent.path = path
        urlComponent.queryItems = options.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        var request = URLRequest(url: urlComponent.url!)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(appContext.accessToken ?? "")", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
