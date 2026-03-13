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
    case bookAppointment(branchName: String, serviceId: String, userId: String, date: String, time: String)
    case getDashboard(userId: String)
    case redeemPoints(userId: String, points: Int)
    
    var path: String {
        switch self {
        case .login: return "apis/login"
        case .createAccount: return "apis/createAccount"
        case .getPromotions: return "apis/getPromotions"
        case .getUserAppointments: return "apis/getUserAppointments"
        case .getAllServices: return "apis/getAllServices"
        case .getTiers: return "apis/getTiers"
        case .sendOTP: return "apis/sendOtp"
        case .verifyOtp: return "apis/verifyOtp"
        case .updatePassword: return "apis/updatePassword"
        case .bookAppointment: return "apis/bookAppointment"
        case .getDashboard: return "apis/getDashboard"
        case .redeemPoints: return "apis/redeemPoints"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .createAccount, .getUserAppointments, .sendOTP, .verifyOtp, .updatePassword,
             .bookAppointment, .getDashboard, .redeemPoints: return .post
        case .getPromotions, .getAllServices, .getTiers: return .get
        }
    }
    
    /// Endpoints that use Authorization: Login@123 (getTiers, bookAppointment, getDashboard, redeemPoints, getUserAppointments) or auth flows
    var authorizationHeader: String? {
        let raw: String?
        switch self {
        case .getTiers, .getUserAppointments, .bookAppointment, .getDashboard, .redeemPoints: raw = APIConfig.authTokenGetTiers
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
        case .bookAppointment(let branchName, let serviceId, let userId, let date, let time):
            let params: [String: Any] = [
                "branchName": branchName,
                "serviceId": serviceId,
                "userid": userId,
                "date": date,
                "time": time
            ]
            return try? JSONSerialization.data(withJSONObject: params)
        case .getDashboard(let userId):
            let params: [String: Any] = ["userid": Int(userId) ?? 1]
            return try? JSONSerialization.data(withJSONObject: params)
        case .redeemPoints(let userId, let points):
            let params: [String: Any] = [
                "userid": Int(userId) ?? 1,
                "points": points
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
