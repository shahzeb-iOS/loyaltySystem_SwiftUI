//
//  APIConfig.swift
//  LoyaltySystem
//
//  API configuration - base URL and constants
//

import Foundation

enum APIConfig {
    static let baseURL = "https://imagetoallconverter.com/clientApps/dermashap/"
    
    /// Build full image URL from base URL + image path. Use for loading images from API (e.g. latestPromotion.imagePath, service.image).
    static func imageURL(imagePath: String?) -> URL? {
        guard let path = imagePath, !path.isEmpty else { return nil }
        if path.hasPrefix("http") { return URL(string: path) }
        let base = baseURL.hasSuffix("/") ? baseURL : baseURL + "/"
        let trimmed = path.hasPrefix("/") ? String(path.dropFirst()) : path
        return URL(string: base + trimmed)
    }
    
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
