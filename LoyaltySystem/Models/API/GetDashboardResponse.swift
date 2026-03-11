//
//  GetDashboardResponse.swift
//  LoyaltySystem
//
//  getDashboard API – matches: {"status":true,"data":{...}}
//

import Foundation

struct GetDashboardResponse: Decodable {
    let status: Bool?
    let data: DashboardData?
}

struct DashboardData: Decodable {
    let totalSpendings: Int?
    let servicesUsed: Int?
    let points: Int?
    let pointsValue: Double?
    let upcomingAppointment: UpcomingAppointmentItem?
    let latestPromotion: LatestPromotionItem?
    let userTier: UserTierItem?
}

struct UpcomingAppointmentItem: Decodable {
    let id: Int?
    let branchName: String?
    let date: String?
    let time: String?
    let title: String?
    let image: String?
}

struct LatestPromotionItem: Decodable {
    let id: Int?
    let imagePath: String?
    let startDate: String?
    let endDate: String?
}

struct UserTierItem: Decodable {
    let currentTier: String?
    let nextTier: String?
    let nextTierSpendings: String?
    let remainingSpendForNextTier: Int?
}

/// Used by DataService/UI – mapped from UpcomingAppointmentItem
struct DashboardAppointmentItem {
    let id: Int?
    let serviceName: String?
    let location: String?
    let branchName: String?
    let status: String?
    let date: String?
    let time: String?
    let points: Int?
    
    init(id: Int?, serviceName: String?, location: String?, branchName: String?, status: String?, date: String?, time: String?, points: Int?) {
        self.id = id
        self.serviceName = serviceName
        self.location = location
        self.branchName = branchName
        self.status = status
        self.date = date
        self.time = time
        self.points = points
    }
}
