//
//  APIEndpoint.swift
//  LoyaltySystem
//
//  API endpoints and request configuration
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum APIEndpoint {
    case login(email: String, password: String, fcmToken: String)
    case createAccount(fullName: String, email: String, password: String, phone: String, dob: String)
    
    var path: String {
        switch self {
        case .login: return "/login"
        case .createAccount: return "/createAccount"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .createAccount: return .post
        }
    }
    
    var fullURL: URL? {
        URL(string: APIConfig.baseURL + path)
    }
    
    var body: Data? {
        switch self {
        case .login(let email, let password, let fcmToken):
            let params: [String: Any] = [
                "email": email,
                "password": password,
                "fcmToken": fcmToken
            ]
            return try? JSONSerialization.data(withJSONObject: params)
        case .createAccount(let fullName, let email, let password, let phone, let dob):
            let params: [String: Any] = [
                "fullName": fullName,
                "email": email,
                "password": password,
                "phone": phone,
                "dob": dob
            ]
            return try? JSONSerialization.data(withJSONObject: params)
        }
    }
    
    var urlRequest: URLRequest? {
        guard let url = fullURL else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = APIConfig.defaultHeaders
        request.httpBody = body
        return request
    }
}
