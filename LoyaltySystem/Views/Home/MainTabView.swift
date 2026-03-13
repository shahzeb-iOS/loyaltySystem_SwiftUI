//
//  MainTabView.swift
//  LoyaltySystem
//
//  Tab bar with Home, Rewards, Center +, History, Profile
//

import SwiftUI

/// Used so catalog opens with correct tab when presented from tab bar or Home.
struct CatalogPresentationItem: Identifiable {
    var openWithPromotionsSelected: Bool
    var id: String { openWithPromotionsSelected ? "promotions" : "catalog" }
}

enum MainTab: Int, CaseIterable {
    case home = 0
    case rewards = 1
    case center = 2
    case history = 3
    case profile = 4
}

struct MainTabView: View {
    let loggedInUser: LoggedInUser
    let onLogout: () -> Void
    @StateObject private var dataService = DataService.shared
    @State private var selectedTab: MainTab = .home
    @State private var hasLoadedHomeOnce = false
    @State private var isRefreshingHome = false
    @State private var catalogPresentation: CatalogPresentationItem?
    
    /// Loader only on Home/Center tab – History/Profile apna khud dikhate hain, doosra spinner + gray na aaye
    private var showHomeLoader: Bool {
        let onHomeTab = (selectedTab == .home || selectedTab == .center)
        guard onHomeTab else { return false }
        let notLoadedYet = !hasLoadedHomeOnce
        if notLoadedYet { return true }
        return isRefreshingHome || dataService.isLoadingDashboard || dataService.isLoadingServices
            || dataService.isLoadingPromotions || dataService.isLoadingAppointments
    }
    
    private var homeView: some View {
        HomeView(loggedInUser: loggedInUser, dataService: dataService, hasLoadedOnce: $hasLoadedHomeOnce, isRefreshingHome: $isRefreshingHome, catalogPresentation: $catalogPresentation, onOpenHistory: { selectedTab = .history })
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                NavigationView {
                    ZStack {
                        homeView
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .opacity(selectedTab == .home || selectedTab == .center ? 1 : 0)
                            .allowsHitTesting(selectedTab == .home || selectedTab == .center)
                        
                        if selectedTab == .rewards {
                            EmptyView()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        if selectedTab == .history {
                            HistoryView(userId: loggedInUser.id, dataService: dataService, onBack: { selectedTab = .home })
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        if selectedTab == .profile {
                            ProfileView(loggedInUser: loggedInUser, onBack: { selectedTab = .home }, onSignOut: onLogout)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .navigationBarHidden(true)
                }
                .navigationViewStyle(.stack)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                tabBar
            }
            .ignoresSafeArea(.keyboard)
            
            if showHomeLoader {
                LoadingOverlay()
                    .ignoresSafeArea()
            }
        }
        .fullScreenCover(item: $catalogPresentation) { item in
            CatalogView(
                dataService: dataService,
                userId: loggedInUser.id,
                initialTab: item.openWithPromotionsSelected ? .promotions : nil,
                onBack: { catalogPresentation = nil }
            )
        }
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
            if tab == .rewards {
                catalogPresentation = CatalogPresentationItem(openWithPromotionsSelected: false)
                return
            }
            if tab == .history {
                selectedTab = .history
                return
            }
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
            catalogPresentation = CatalogPresentationItem(openWithPromotionsSelected: false)
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
        MainTabView(loggedInUser: LoggedInUser(id: "1", name: "Yuly", email: "yuly@example.com"), onLogout: {})
    }
}
