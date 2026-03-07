//
//  PromotionsResponse.swift
//  LoyaltySystem
//
//  getPromotions API response
//

import Foundation

struct PromotionsResponse: Decodable {
    let status: Bool?
    let message: String?
    let promotions: [PromotionItem]?
}

struct PromotionItem: Decodable, Identifiable {
    let id: Int?
    let title: String?
    let details: String?
    let image: String?
    let points: Int?
    let offPercentage: Int?
    let price: Int?
    let discountedPrice: Int?
}
