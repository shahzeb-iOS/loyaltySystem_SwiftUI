//
//  APIConfig.swift
//  LoyaltySystem
//
//  API configuration - base URL and constants
//

import Foundation

enum APIConfig {
    static let baseURL = "https://imagetoallconverter.com/clientApps/dermashap/apis"
    
    /// Auth token for getTiers (Authorization header)
    static let authTokenGetTiers = "Login@123"
    /// Auth token for sendOtp, verifyOtp, updatePassword
    static let authTokenAuth = "Login@123"
    
    /// If your server expects "Bearer <token>", set to true. Else sends raw token.
    static let useBearerAuth = true
    
    static var defaultHeaders: [String: String] {
        [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
}
