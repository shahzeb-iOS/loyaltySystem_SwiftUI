//
//  PromotionsResponse.swift
//  LoyaltySystem
//
//  getPromotions API – matches: {"status":true,"message":"...","promotions":[...]}
//

import Foundation

struct PromotionsResponse: Decodable {
    let status: Bool?
    let message: String?
    let promotions: [PromotionItem]?
}

struct PromotionItem: Decodable, Identifiable {
    let id: Int?
    let imagePath: String?
    let isActive: Int?
    let startDate: String?
    let endDate: String?
    let title: String?
    let points: Int?
    let offPercentage: Int?
    
    /// For UI that expects image URL
    var image: String? { imagePath }
}
