//
//  NotificationsView.swift
//  LoyaltySystem
//
//  Notifications screen - points earned, appointment reminders
//

import SwiftUI

struct NotificationsView: View {
    let onDismiss: () -> Void
    
    @State private var notifications: [NotificationItem] = [
        NotificationItem(iconName: "chart.bar.fill", iconColor: "green", title: "Points Earned", detail: "You earned 15 points on your last visit!", timestamp: "5hr ago"),
        NotificationItem(iconName: "calendar", iconColor: "gold", title: "Appointment Reminder", detail: "Classic Facial in 2 days at 02:30 PM", timestamp: "8hr ago")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with close button
            HStack {
                Spacer()
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.appTextSecondary)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 8)
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 16) {
                    ForEach(notifications) { item in
                        notificationCard(item)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .background(Color.appBackgroundWhite)
    }
    
    private func notificationCard(_ item: NotificationItem) -> some View {
        HStack(alignment: .top, spacing: 16) {
            // Icon circle
            ZStack {
                Color.appLightBeige
                Image(systemName: item.iconName)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(item.iconColor == "green" ? Color.green : Color.appAccentGold)
            }
            .frame(width: 48, height: 48)
            .clipShape(Circle())
            
            // Content
            VStack(alignment: .leading, spacing: 6) {
                Text(item.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                
                Text(item.detail)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.appTextSecondary)
                
                Text(item.timestamp)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.appTextSecondary.opacity(0.7))
            }
            
            Spacer(minLength: 0)
        }
        .padding(16)
        .background(Color.appBackgroundWhite)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.appTextSecondary.opacity(0.1), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
    }
}

#Preview {
    NotificationsView(onDismiss: {})
}
