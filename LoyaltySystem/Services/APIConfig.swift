//
//  APIConfig.swift
//  LoyaltySystem
//
//  API configuration - base URL and constants
//

import Foundation

enum APIConfig {
    static let baseURL = "https://imagetoallconverter.com/clientApps/dermashap/apis"
    
    static var defaultHeaders: [String: String] {
        [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
}
