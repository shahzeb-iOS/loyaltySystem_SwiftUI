//
//  UserAppointmentsResponse.swift
//  LoyaltySystem
//
//  getUserAppointments API – matches: {"status":true,"message":"...","appointments":[...]}
//

import Foundation

struct UserAppointmentsResponse: Decodable {
    let status: Bool?
    let message: String?
    let appointments: [AppointmentItem]?
}

struct AppointmentItem: Decodable, Identifiable {
    private let idValue: Int?
    var id: Int { idValue ?? 0 }
    let branchName: String?
    let serviceId: String?
    let userid: Int?
    let date: String?
    let time: String?
    let approval_status: String?
    let service_title: String?
    let service_details: Int?
    let service_time: Int?
    let service_price: Int?
    let service_image: String?
    let service_points: Int?
    let off_Percentage: Int?
    let appointment_status: String?
    
    enum CodingKeys: String, CodingKey {
        case idValue = "id"
        case branchName, serviceId, userid, date, time
        case approval_status, service_title, service_details, service_time
        case service_price, service_image, service_points, off_Percentage, appointment_status
    }
    
    /// For display – map service_title to serviceName
    var serviceName: String? { service_title }
    /// For display – branch as location
    var location: String? { branchName }
    /// For display – approval or appointment status
    var status: String? { approval_status ?? appointment_status }
    var points: Int? { service_points }
}
