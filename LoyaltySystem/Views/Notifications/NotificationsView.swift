//
//  NotificationsView.swift
//  LoyaltySystem
//
//  Notifications screen - points earned, appointment reminders
//

import SwiftUI

struct NotificationsView: View {
    let userId: String
    @ObservedObject var dataService: DataService
    let onDismiss: () -> Void

    private var displayItems: [NotificationItem] {
        dataService.notifications.map { $0.toNotificationItem() }
    }

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

            if dataService.isLoadingNotifications {
                LoadingOverlay()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if displayItems.isEmpty {
                Spacer()
                Text("No notifications")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.appTextSecondary)
                Spacer()
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 16) {
                        ForEach(displayItems) { item in
                            notificationCard(item)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .background(Color.appBackgroundWhite)
        .task {
            await dataService.fetchNotifications(userId: userId)
        }
    }
    
    private func notificationCard(_ item: NotificationItem) -> some View {
        HStack(alignment: .top, spacing: 16) {
            // Icon circle
            ZStack {
                Color.appLightBeige
                Image(systemName: item.iconName)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(item.iconColor == "green" ? Color.green : (item.iconColor == "gold" ? Color.appAccentGold : Color.appAccentGold))
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

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView(userId: "1", dataService: DataService.shared, onDismiss: {})
    }
}
