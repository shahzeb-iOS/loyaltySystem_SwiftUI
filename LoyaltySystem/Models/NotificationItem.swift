//
//  NotificationItem.swift
//  LoyaltySystem
//
//  Model for notification items
//

import Foundation

struct NotificationItem: Identifiable {
    let id = UUID()
    let iconName: String
    let iconColor: String  // "green" or "gold"
    let title: String
    let detail: String
    let timestamp: String
}
