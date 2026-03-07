//
//  LoginResponse.swift
//  LoyaltySystem
//
//  Login API response model - flexible for various response structures
//

import Foundation

struct LoginResponse: Decodable {
    let success: Bool?
    let message: String?
    let data: LoginData?
    let token: String?
    let user: UserData?
}

struct LoginData: Decodable {
    let token: String?
    let user: UserData?
}

struct UserData: Decodable {
    let id: Int?
    let name: String?
    let fullName: String?
    let email: String?
    let phone: String?
}
