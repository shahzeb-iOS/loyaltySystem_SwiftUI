//
//  MessageResponse.swift
//  LoyaltySystem
//
//  Generic success/message response for sendOTP, verifyOtp, updatePassword
//

import Foundation

struct MessageResponse: Decodable {
    let success: Bool?
    let status: Bool?
    let message: String?
}
