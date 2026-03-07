//
//  UserAppointmentsResponse.swift
//  LoyaltySystem
//
//  getUserAppointments API response
//

import Foundation

struct UserAppointmentsResponse: Decodable {
    let status: Bool?
    let message: String?
    let appointments: [AppointmentItem]?
}

struct AppointmentItem: Decodable, Identifiable {
    let id: Int?
    let serviceName: String?
    let location: String?
    let status: String?
    let date: String?
    let time: String?
    let points: Int?
}
