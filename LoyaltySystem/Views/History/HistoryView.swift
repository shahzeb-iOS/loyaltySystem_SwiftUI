//
//  HistoryView.swift
//  LoyaltySystem
//
//  History screen - past and upcoming appointments
//

import SwiftUI

enum HistoryFilter: String, CaseIterable {
    case all = "All"
    case upcoming = "Upcoming"
    case past = "Past"
}

struct HistoryView: View {
    let onBack: () -> Void
    
    @State private var selectedFilter: HistoryFilter = .all
    @State private var historyEntries: [HistoryEntry] = [
        HistoryEntry(serviceName: "Classic Facial", location: "Lahore Spa", status: .upcoming, date: "Feb 14, 2026", time: "10:00 AM", points: 10),
        HistoryEntry(serviceName: "Classic Facial", location: "Lahore Spa", status: .completed, date: "Feb 10, 2026", time: "11:00 AM", points: 10)
    ]
    
    private var filteredEntries: [HistoryEntry] {
        switch selectedFilter {
        case .all: return historyEntries
        case .upcoming: return historyEntries.filter { $0.status == .upcoming }
        case .past: return historyEntries.filter { $0.status == .completed }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            header
            segmentedControl
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 16)
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 16) {
                    ForEach(filteredEntries) { entry in
                        historyCard(entry)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
        .background(Color.appBackgroundWhite)
    }
    
    private var header: some View {
        HStack(spacing: 16) {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.appTextSecondary)
                    .frame(width: 44, height: 44)
                    .background(Color.appLightBeige)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            
            Text("History")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.black)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 12)
    }
    
    private var segmentedControl: some View {
        HStack(spacing: 0) {
            ForEach(HistoryFilter.allCases, id: \.self) { filter in
                Button {
                    selectedFilter = filter
                } label: {
                    Text(filter.rawValue)
                        .font(.system(size: 14, weight: selectedFilter == filter ? .bold : .regular))
                        .foregroundColor(selectedFilter == filter ? .black : .appTextSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(selectedFilter == filter ? Color.appBackgroundWhite : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: selectedFilter == filter ? .black.opacity(0.06) : .clear, radius: 2, x: 0, y: 1)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(Color.appLightBeige)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func historyCard(_ entry: HistoryEntry) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Top row: service name + status tag
            HStack(alignment: .top) {
                Text(entry.serviceName)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Text(entry.status.rawValue)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(entry.status == .upcoming ? .appAccentGold : .appTextSecondary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(entry.status == .upcoming ? Color.appAccentGold.opacity(0.25) : Color.appTextSecondary.opacity(0.2))
                    .clipShape(Capsule())
            }
            
            // Location
            HStack(spacing: 4) {
                Image(systemName: "mappin")
                    .font(.system(size: 12))
                    .foregroundColor(.appTextSecondary)
                Text(entry.location)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.appTextSecondary)
            }
            
            // Separator
            Rectangle()
                .fill(Color.appTextSecondary.opacity(0.2))
                .frame(height: 1)
                .padding(.top, 20)
                .padding(.bottom, 10)
            
            // Bottom row: date, time, points
            HStack(alignment: .center) {
                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .font(.system(size: 14))
                        .foregroundColor(.appTextPrimary)
                    Text(entry.date)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.black)
                    Text(entry.time)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                HStack(spacing: 2) {
                    Text("+\(entry.points)")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.black)
                    Text("PTS")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.appAccentGold)
                }
            }
        }
        .padding(20)
        .background(Color.appBackgroundWhite)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.appTextSecondary.opacity(0.08), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
    }
}

#Preview {
    HistoryView(onBack: {})
}
