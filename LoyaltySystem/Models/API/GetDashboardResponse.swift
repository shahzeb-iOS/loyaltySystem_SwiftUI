//
//  GetDashboardResponse.swift
//  LoyaltySystem
//
//  getDashboard API response
//

import Foundation

struct GetDashboardResponse: Decodable {
    let status: Bool?
    let message: String?
    let points: Int?
    let tierName: String?
    let nextAppointment: DashboardAppointmentItem?
    let appointments: [AppointmentItem]?
    /// For tier progress bar: (currentSpending / nextTierSpending) * 100
    let currentSpending: Int?
    let nextTierSpending: Int?
    
    enum CodingKeys: String, CodingKey {
        case status, message, points, tierName, nextAppointment, appointments
        case currentSpending, nextTierSpending
        case current_spending, next_tier_spending
    }
    
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        status = try c.decodeIfPresent(Bool.self, forKey: .status)
        message = try c.decodeIfPresent(String.self, forKey: .message)
        points = try c.decodeIfPresent(Int.self, forKey: .points)
        tierName = try c.decodeIfPresent(String.self, forKey: .tierName)
        nextAppointment = try c.decodeIfPresent(DashboardAppointmentItem.self, forKey: .nextAppointment)
        appointments = try c.decodeIfPresent([AppointmentItem].self, forKey: .appointments)
        let curCamel = try c.decodeIfPresent(Int.self, forKey: .currentSpending)
        let curSnake = try c.decodeIfPresent(Int.self, forKey: .current_spending)
        currentSpending = curCamel ?? curSnake
        let nextCamel = try c.decodeIfPresent(Int.self, forKey: .nextTierSpending)
        let nextSnake = try c.decodeIfPresent(Int.self, forKey: .next_tier_spending)
        nextTierSpending = nextCamel ?? nextSnake
    }
}

struct DashboardAppointmentItem: Decodable {
    let id: Int?
    let serviceName: String?
    let location: String?
    let branchName: String?
    let status: String?
    let date: String?
    let time: String?
    let points: Int?
}
