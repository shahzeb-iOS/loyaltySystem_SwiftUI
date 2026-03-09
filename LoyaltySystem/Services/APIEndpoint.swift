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
    case getPromotions
    case getUserAppointments(userId: String, status: String)
    case getAllServices
    case getTiers
    case sendOTP(email: String)
    case verifyOtp(email: String, otp: String)
    case updatePassword(email: String, newpassword: String)
    
    var path: String {
        switch self {
        case .login: return "/login"
        case .createAccount: return "/createAccount"
        case .getPromotions: return "/getPromotions"
        case .getUserAppointments: return "/getUserAppointments"
        case .getAllServices: return "/getAllServices"
        case .getTiers: return "/getTiers"
        case .sendOTP: return "/sendOtp"
        case .verifyOtp: return "/verifyOtp"
        case .updatePassword: return "/updatePassword"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .createAccount, .getUserAppointments, .sendOTP, .verifyOtp, .updatePassword: return .post
        case .getPromotions, .getAllServices, .getTiers: return .get
        }
    }
    
    /// Endpoints that use Authorization: Login@123 (getTiers) or Login@1234 (auth flows)
    var authorizationHeader: String? {
        let raw: String?
        switch self {
        case .getTiers: raw = APIConfig.authTokenGetTiers
        case .sendOTP, .verifyOtp, .updatePassword: raw = APIConfig.authTokenAuth
        default: raw = nil
        }
        guard let raw = raw else { return nil }
        return APIConfig.useBearerAuth ? "Bearer \(raw)" : raw
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
        case .getUserAppointments(let userId, let status):
            let params: [String: Any] = [
                "userid": userId,
                "status": status
            ]
            return try? JSONSerialization.data(withJSONObject: params)
        case .sendOTP(let email):
            let params: [String: Any] = ["email": email]
            return try? JSONSerialization.data(withJSONObject: params)
        case .verifyOtp(let email, let otp):
            let params: [String: Any] = ["email": email, "otp": otp]
            return try? JSONSerialization.data(withJSONObject: params)
        case .updatePassword(let email, let newpassword):
            let params: [String: Any] = ["email": email, "newpassword": newpassword]
            return try? JSONSerialization.data(withJSONObject: params)
        case .getPromotions, .getAllServices, .getTiers:
            return nil
        }
    }
    
    var urlRequest: URLRequest? {
        guard let url = fullURL else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        var headers = APIConfig.defaultHeaders
        if let auth = authorizationHeader {
            headers["Authorization"] = auth
        }
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        return request
    }
}
