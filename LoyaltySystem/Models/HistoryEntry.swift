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
    /// Approval/status text from API (approval_status or appointment_status) – shown in cell
    let approvalStatusDisplay: String
    let date: String
    let time: String
    let points: Int
    
    init(id: Int = Int.random(in: 1...99999), serviceName: String, location: String, status: HistoryStatus, approvalStatusDisplay: String = "", date: String, time: String, points: Int) {
        self.id = id
        self.serviceName = serviceName
        self.location = location
        self.status = status
        self.approvalStatusDisplay = approvalStatusDisplay
        self.date = date
        self.time = time
        self.points = points
    }
    
    static func from(_ appointment: AppointmentItem) -> HistoryEntry {
        let rawStatus = (appointment.appointment_status ?? appointment.approval_status ?? appointment.status ?? "").uppercased()
        let historyStatus: HistoryStatus
        if rawStatus == "UPCOMING" || rawStatus == "A" || rawStatus == "PENDING" {
            historyStatus = .upcoming
        } else if rawStatus == "COMPLETED" || rawStatus == "P" || rawStatus == "DONE" {
            historyStatus = .completed
        } else {
            historyStatus = .completed
        }
        let displayStatus = appointment.approval_status ?? appointment.appointment_status ?? appointment.status ?? ""
        return HistoryEntry(
            id: appointment.id ?? Int.random(in: 1...99999),
            serviceName: appointment.serviceName ?? "",
            location: appointment.location ?? "",
            status: historyStatus,
            approvalStatusDisplay: displayStatus.isEmpty ? "—" : displayStatus,
            date: appointment.date ?? "",
            time: appointment.time ?? "",
            points: appointment.points ?? 0
        )
    }
}
