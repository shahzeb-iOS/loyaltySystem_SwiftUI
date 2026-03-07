//
//  ServicesResponse.swift
//  LoyaltySystem
//
//  getAllServices API response
//

import Foundation

struct ServicesResponse: Decodable {
    let status: Bool?
    let message: String?
    let services: [ServiceItem]?
}

struct ServiceItem: Decodable, Identifiable {
    let id: Int
    let title: String
    let details: Int?
    let time: Int?
    let price: Int?
    let discountedPrice: Int?
    let image: String?
    let points: Int?
    let offPercentage: Int?
}
