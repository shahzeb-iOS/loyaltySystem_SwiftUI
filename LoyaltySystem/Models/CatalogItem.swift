//
//  CatalogItem.swift
//  LoyaltySystem
//
//  Model for catalog/rewards items
//

import Foundation

struct CatalogItem: Identifiable {
    let id: Int
    let title: String
    let duration: String?  // e.g. "30 Min" - nil for products
    let price: String
    let points: Int
    let discount: String   // e.g. "50% off", "10% off"
    let imageName: String  // SF Symbol name for placeholder
    /// API image path – load with base URL + this path
    let imagePath: String?
    
    init(id: Int = Int.random(in: 1...99999), title: String, duration: String?, price: String, points: Int, discount: String, imageName: String, imagePath: String? = nil) {
        self.id = id
        self.title = title
        self.duration = duration
        self.price = price
        self.points = points
        self.discount = discount
        self.imageName = imageName
        self.imagePath = imagePath
    }
    
    static func from(_ service: ServiceItem) -> CatalogItem {
        let duration = service.time.map { "\($0) Min" }
        let priceStr = service.price.map { "$\($0)" } ?? "$0"
        let discount = (service.offPercentage ?? 0) > 0 ? "\(service.offPercentage ?? 0)% off" : "0% off"
        return CatalogItem(
            id: service.id,
            title: service.title,
            duration: duration,
            price: priceStr,
            points: service.points ?? 0,
            discount: discount,
            imageName: "face.smiling",
            imagePath: service.image
        )
    }
    
    static func from(_ promo: PromotionItem) -> CatalogItem {
        let priceVal = promo.isActive ?? promo.offPercentage ?? 0
        let discount = (promo.offPercentage ?? 0) > 0 ? "\(promo.offPercentage ?? 0)% off" : "0% off"
        return CatalogItem(
            id: promo.id ?? Int.random(in: 1...99999),
            title: promo.title ?? "",
            duration: nil,
            price: "$\(priceVal)",
            points: promo.points ?? 0,
            discount: discount,
            imageName: "gift.fill",
            imagePath: promo.imagePath
        )
    }
}
