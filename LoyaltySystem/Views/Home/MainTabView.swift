//
//  MainTabView.swift
//  LoyaltySystem
//
//  Tab bar with Home, Rewards, Center +, History, Profile
//

import SwiftUI

enum MainTab: Int, CaseIterable {
    case home = 0
    case rewards = 1
    case center = 2
    case history = 3
    case profile = 4
}

struct MainTabView: View {
    let loggedInUser: LoggedInUser
    @StateObject private var dataService = DataService.shared
    @State private var selectedTab: MainTab = .home
    
    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch selectedTab {
                case .home:
                    HomeView(loggedInUser: loggedInUser, dataService: dataService)
                case .rewards:
                    RewardsPlaceholderView()
                case .center:
                    HomeView(loggedInUser: loggedInUser, dataService: dataService)
                case .history:
                    HistoryView(userId: loggedInUser.id, dataService: dataService, onBack: { selectedTab = .home })
                case .profile:
                    ProfileView(loggedInUser: loggedInUser, onBack: { selectedTab = .home })
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            tabBar
        }
        .ignoresSafeArea(.keyboard)
    }
    
    private var tabBar: some View {
        HStack(spacing: 0) {
            tabItem(.home, icon: "house.fill", label: "Home")
            tabItem(.rewards, icon: "gift", label: "Rewards")
            
            centerButton
            
            tabItem(.history, icon: "clock.arrow.circlepath", label: "History")
            tabItem(.profile, icon: "person", label: "Profile")
        }
        .padding(.top, 12)
        .padding(.bottom, 24)
        .padding(.horizontal, 8)
        .background(
            Color.appBackgroundWhite
                .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: -4)
        )
        .overlay(
            Rectangle()
                .fill(Color.appTextSecondary.opacity(0.2))
                .frame(height: 1),
            alignment: .top
        )
    }
    
    private func tabItem(_ tab: MainTab, icon: String, label: String) -> some View {
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .regular))
                Text(label)
                    .font(.system(size: 10, weight: .regular))
            }
            .foregroundColor(selectedTab == tab ? .appAccentGold : .appTextSecondary)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
    
    private var centerButton: some View {
        Button {
            selectedTab = .center
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(Color.appPrimaryDark)
                .clipShape(Circle())
                .offset(y: -16)
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
    }
}

struct RewardsPlaceholderView: View {
    var body: some View {
        Color.appBackgroundWhite
            .overlay(
                Text("Rewards")
                    .font(.appTitle)
                    .foregroundColor(.appTextPrimary)
            )
    }
}

struct HistoryPlaceholderView: View {
    var body: some View {
        Color.appBackgroundWhite
            .overlay(
                Text("History")
                    .font(.appTitle)
                    .foregroundColor(.appTextPrimary)
            )
    }
}

struct ProfilePlaceholderView: View {
    var body: some View {
        Color.appBackgroundWhite
            .overlay(
                Text("Profile")
                    .font(.appTitle)
                    .foregroundColor(.appTextPrimary)
            )
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(loggedInUser: LoggedInUser(id: "1", name: "Yuly", email: "yuly@example.com"))
    }
}
