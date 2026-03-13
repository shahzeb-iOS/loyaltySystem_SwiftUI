//
//  APIService.swift
//  LoyaltySystem
//
//  Network service - executes API requests
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case serverError(message: String)
    case decodingError
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .invalidResponse: return "Invalid response"
        case .httpError(let code): return "Server returned HTTP \(code)"
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
        
        // Log request
        let urlString = request.url?.absoluteString ?? "unknown"
        print("[API Request] \(request.httpMethod ?? "?") \(urlString)")
        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            print("[API Request Headers] \(headers)")
        }
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            print("[API Request Body] \(bodyString)")
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            let responseString = String(data: data, encoding: .utf8) ?? "<non-UTF8>"
            print("[API Response] HTTP \(httpResponse.statusCode) \(urlString)")
            print("[API Response Body] \(responseString)")
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("[API Error] HTTP \(httpResponse.statusCode) – check response body above")
                if let errorMsg = parseErrorMessage(from: data) {
                    throw APIError.serverError(message: errorMsg)
                }
                throw APIError.httpError(statusCode: httpResponse.statusCode)
            }
            
            let jsonData = stripLeadingNonJSON(from: data)
            let decoder = JSONDecoder()
            do {
                return try decoder.decode(T.self, from: jsonData)
            } catch {
                if let msg = parseErrorMessage(from: jsonData) {
                    throw APIError.serverError(message: msg)
                }
                throw APIError.networkError(error)
            }
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    /// Removes PHP/HTML prefix so only JSON is left (e.g. "{\"status\":false,\"message\":\"...\"}")
    private func stripLeadingNonJSON(from data: Data) -> Data {
        guard let str = String(data: data, encoding: .utf8),
              let start = str.firstIndex(of: "{") else { return data }
        let jsonPart = String(str[start...])
        return Data(jsonPart.utf8)
    }
    
    private func parseErrorMessage(from data: Data) -> String? {
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return nil }
        return (json["message"] as? String) ?? (json["error"] as? String) ?? (json["msg"] as? String)
    }
    
    func requestRaw(_ endpoint: APIEndpoint) async throws -> (Data, HTTPURLResponse) {
        guard let request = endpoint.urlRequest else {
            throw APIError.invalidURL
        }
        let urlString = request.url?.absoluteString ?? "unknown"
        print("[API Request] \(request.httpMethod ?? "?") \(urlString)")
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            print("[API Request Body] \(bodyString)")
        }
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        print("[API Response] \(httpResponse.statusCode) \(urlString)")
        print("[API Response Body] \(String(data: data, encoding: .utf8) ?? "<non-UTF8>")")
        return (data, httpResponse)
    }
}
