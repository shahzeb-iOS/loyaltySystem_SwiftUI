//
//  CreateAccountResponse.swift
//  LoyaltySystem
//
//  Create account API response model - API returns "status" not "success"
//

import Foundation

struct CreateAccountResponse: Decodable {
    let status: Bool?
    let success: Bool?
    let message: String?
    let user: UserData?
    let data: CreateAccountData?
}

struct CreateAccountData: Decodable {
    let user: UserData?
}
