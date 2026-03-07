//
//  CreateAccountResponse.swift
//  LoyaltySystem
//
//  Create account API response model
//

import Foundation

struct CreateAccountResponse: Decodable {
    let success: Bool?
    let message: String?
    let data: CreateAccountData?
}

struct CreateAccountData: Decodable {
    let user: UserData?
}
