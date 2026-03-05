//
//  CatalogItem.swift
//  LoyaltySystem
//
//  Model for catalog/rewards items
//

import Foundation

struct CatalogItem: Identifiable {
    let id = UUID()
    let title: String
    let duration: String?  // e.g. "30 Min" - nil for products
    let price: String
    let points: Int
    let discount: String   // e.g. "50% off", "10% off"
    let imageName: String  // SF Symbol name for placeholder
}
