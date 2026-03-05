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
    let id = UUID()
    let serviceName: String
    let location: String
    let status: HistoryStatus
    let date: String
    let time: String
    let points: Int
}
