//
//  OnboardingItem.swift
//  LoyaltySystem
//
//  Model for onboarding screen content
//

import Foundation

struct OnboardingItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String
    
    static let items: [OnboardingItem] = [
        OnboardingItem(
            title: "Book Appointments",
            description: "Easily schedule your favorite services with your preferred specialists.",
            imageName: "calender"
        ),
        OnboardingItem(
            title: "Earn Points",
            description: "Every visit brings you closer to exclusive rewards and membership perks.",
            imageName: "earnPoints"
        ),
        OnboardingItem(
            title: "Exclusive Rewards",
            description: "Redeem your points for treatments, products, and special discounts.",
            imageName: "rewards"
        )
    ]
}
