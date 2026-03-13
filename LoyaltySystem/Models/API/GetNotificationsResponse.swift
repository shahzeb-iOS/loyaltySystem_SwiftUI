//
//  GetNotificationsResponse.swift
//  LoyaltySystem
//
//  getNotifications API response
//

import Foundation

struct GetNotificationsResponse: Decodable {
    let status: Bool?
    let message: String?
    let notifications: [NotificationApiItem]?
}

struct NotificationApiItem: Decodable, Identifiable {
    let id: Int?
    let title: String?
    let message: String?
    let date: String?
    let type: String?
    
    /// Map to NotificationItem for UI
    func toNotificationItem() -> NotificationItem {
        let iconName: String
        let iconColor: String
        switch (type ?? "").lowercased() {
        case "points", "reward": iconName = "chart.bar.fill"; iconColor = "green"
        case "appointment", "reminder": iconName = "calendar"; iconColor = "gold"
        default: iconName = "bell.fill"; iconColor = "gold"
        }
        return NotificationItem(
            iconName: iconName,
            iconColor: iconColor,
            title: title ?? "",
            detail: message ?? "",
            timestamp: date ?? ""
        )
    }
}
