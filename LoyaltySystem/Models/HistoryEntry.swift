//
//  HistoryEntry.swift
//  LoyaltySystem
//
//  Model for history/appointment entries
//

import Foundation

enum HistoryStatus: String {
    case upcoming = "Upcoming"
    case completed = "Completed"
}

struct HistoryEntry: Identifiable {
    let id: Int
    let serviceName: String
    let location: String
    let status: HistoryStatus
    let date: String
    let time: String
    let points: Int
    
    init(id: Int = Int.random(in: 1...99999), serviceName: String, location: String, status: HistoryStatus, date: String, time: String, points: Int) {
        self.id = id
        self.serviceName = serviceName
        self.location = location
        self.status = status
        self.date = date
        self.time = time
        self.points = points
    }
    
    static func from(_ appointment: AppointmentItem) -> HistoryEntry {
        let statusStr = (appointment.status ?? "").uppercased()
        let historyStatus: HistoryStatus = (statusStr == "A" || statusStr == "UPCOMING") ? .upcoming : .completed
        return HistoryEntry(
            id: appointment.id ?? Int.random(in: 1...99999),
            serviceName: appointment.serviceName ?? "",
            location: appointment.location ?? "",
            status: historyStatus,
            date: appointment.date ?? "",
            time: appointment.time ?? "",
            points: appointment.points ?? 0
        )
    }
}
