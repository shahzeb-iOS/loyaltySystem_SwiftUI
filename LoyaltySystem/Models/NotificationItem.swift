//
//  NotificationItem.swift
//  LoyaltySystem
//
//  Model for notification items
//

import Foundation

struct NotificationItem: Identifiable {
    let id: UUID
    let iconName: String
    let iconColor: String  // "green" or "gold"
    let title: String
    let detail: String
    let timestamp: String

    init(id: UUID = UUID(), iconName: String, iconColor: String, title: String, detail: String, timestamp: String) {
        self.id = id
        self.iconName = iconName
        self.iconColor = iconColor
        self.title = title
        self.detail = detail
        self.timestamp = timestamp
    }
}
