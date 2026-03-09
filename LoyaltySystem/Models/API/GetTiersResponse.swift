//
//  GetTiersResponse.swift
//  LoyaltySystem
//
//  getTiers API response
//

import Foundation

struct GetTiersResponse: Decodable {
    let status: Bool?
    let message: String?
    let tiers: [TierItem]?
}

struct TierItem: Decodable, Identifiable {
    var id: String { tierId ?? name ?? (description ?? "").prefix(20).description }
    let tierId: String?
    let name: String?
    let description: String?
    let pointsRequired: Int?
    let benefits: [String]?
    let image: String?

    enum CodingKeys: String, CodingKey {
        case tierId, name, description, pointsRequired, benefits, image
        case tier_id, points_required
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        let tierIdCamel = try c.decodeIfPresent(String.self, forKey: .tierId)
        let tierIdSnake = try c.decodeIfPresent(String.self, forKey: .tier_id)
        tierId = tierIdCamel ?? tierIdSnake
        name = try c.decodeIfPresent(String.self, forKey: .name)
        description = try c.decodeIfPresent(String.self, forKey: .description)
        let pointsCamel = try c.decodeIfPresent(Int.self, forKey: .pointsRequired)
        let pointsSnake = try c.decodeIfPresent(Int.self, forKey: .points_required)
        pointsRequired = pointsCamel ?? pointsSnake
        benefits = try c.decodeIfPresent([String].self, forKey: .benefits)
        image = try c.decodeIfPresent(String.self, forKey: .image)
    }
}
