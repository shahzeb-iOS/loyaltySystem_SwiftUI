//
//  LoginResponse.swift
//  LoyaltySystem
//
//  Login API response – matches: {"status":true,"message":"...","user":{...}}
//

import Foundation

struct LoginResponse: Decodable {
    let status: Bool?
    let message: String?
    let user: UserData?
}

struct UserData: Decodable {
    let id: Int?
    let fullName: String?
    let email: String?
    let password: String?
    let phone: String?
    let dob: String?
    let earnedPoints: Int?
    let remainingPoints: Int?
    let redeemedPoints: Int?
    let isAccountActive: Int?
    let fcmToken: String?
    let membership: String?
    let loyalityID: String?
    let userType: String?
    
    /// For display – API sends fullName
    var name: String? { fullName }
}
