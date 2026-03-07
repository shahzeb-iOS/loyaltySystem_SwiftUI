//
//  APIService.swift
//  LoyaltySystem
//
//  Network service - executes API requests
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case serverError(message: String)
    case decodingError
    case networkError(Error)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .invalidResponse: return "Invalid response"
        case .httpError(let code): return "Error: \(code)"
        case .serverError(let msg): return msg
        case .decodingError: return "Failed to parse response"
        case .networkError(let err): return err.localizedDescription
        }
    }
}

final class APIService {
    static let shared = APIService()
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        guard let request = endpoint.urlRequest else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                if let errorMsg = parseErrorMessage(from: data) {
                    throw APIError.serverError(message: errorMsg)
                }
                throw APIError.httpError(statusCode: httpResponse.statusCode)
            }
            
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    private func parseErrorMessage(from data: Data) -> String? {
        (try? JSONSerialization.jsonObject(with: data) as? [String: Any])?["message"] as? String
    }
    
    func requestRaw(_ endpoint: APIEndpoint) async throws -> (Data, HTTPURLResponse) {
        guard let request = endpoint.urlRequest else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        return (data, httpResponse)
    }
}
