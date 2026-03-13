//
//  GetTiersResponse.swift
//  LoyaltySystem
//
//  getTiers API – {"status":true,"message":"...","data":[{id, title, tier_spending, tier_description, tier_benefits}, ...]}
//

import Foundation

struct GetTiersResponse: Decodable {
    let status: Bool?
    let message: String?
    let data: [TierItem]?
    
    var tiers: [TierItem]? { data }
}

struct TierItem: Decodable, Identifiable {
    let idValue: Int?
    let title: String?
    let tierSpending: String?
    let tierDescription: String?
    let tierBenefits: [String]?
    
    enum CodingKeys: String, CodingKey {
        case idValue = "id"
        case title
        case tierSpending = "tier_spending"
        case tierDescription = "tier_description"
        case tierBenefits = "tier_benefits"
    }
    
    var id: Int { idValue ?? 0 }
    
    /// For compatibility with existing code
    var name: String? { title }
    var description: String? { tierDescription }
    var benefits: [String]? { tierBenefits }
    var pointsRequired: Int? { tierSpending.flatMap { Int($0) } }
}
