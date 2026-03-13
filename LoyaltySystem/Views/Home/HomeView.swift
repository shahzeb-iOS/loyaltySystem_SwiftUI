//
//  HomeView.swift
//  LoyaltySystem
//
//  Dashboard / Home screen with points, appointments, promotions
//

import SwiftUI

/// Used so catalog opens with correct tab (Promotions vs All) when presented via fullScreenCover(item:).
private struct CatalogPresentationItem: Identifiable {
    var openWithPromotionsSelected: Bool
    var id: String { openWithPromotionsSelected ? "promotions" : "catalog" }
}

struct HomeView: View {
    let loggedInUser: LoggedInUser
    @ObservedObject var dataService: DataService
    @Binding var hasLoadedOnce: Bool
    @Binding var isRefreshingHome: Bool
    @State private var showBookAppointment = false
    @State private var catalogPresentation: CatalogPresentationItem?
    @State private var showNotifications = false
    @State private var showLoyaltyArchitecture = false
    @State private var showErrorAlert = false
    
    /// Loads dashboard + related data (login pe ek baar, refresh pe dubara). Tiers load on View Tiers screen only.
    private func loadHomeData() async {
        dataService.clearLastError()
        await dataService.fetchDashboard(userId: loggedInUser.id)
        await dataService.fetchAllServices()
        await dataService.fetchPromotions()
        await dataService.fetchUserAppointments(userId: loggedInUser.id, status: "A")
    }
    
    init(loggedInUser: LoggedInUser, dataService: DataService = .shared, hasLoadedOnce: Binding<Bool> = .constant(false), isRefreshingHome: Binding<Bool> = .constant(false)) {
        self.loggedInUser = loggedInUser
        self._dataService = ObservedObject(wrappedValue: dataService)
        self._hasLoadedOnce = hasLoadedOnce
        self._isRefreshingHome = isRefreshingHome
    }
    
    var body: some View {
        VStack(spacing: 0) {
            navigationBar
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    // Header
                    headerSection
                        .padding(.bottom, 24)
                
                // Loyalty Tiers Section
                loyaltyTiersSection
                    .padding(.bottom, 24)
                
                // Quick Actions
                quickActionsSection
                    .padding(.bottom, 24)
                
                // Next Appointment
                nextAppointmentSection
                    .padding(.bottom, 24)
                
                // Promotions
                promotionsSection
                    .padding(.bottom, 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
            .refreshable {
                isRefreshingHome = true
                Task.detached(priority: .userInitiated) { @MainActor in
                    await loadHomeData()
                    isRefreshingHome = false
                }
            }
        }
        .background(Color.appBackgroundWhite)
        .task {
            guard !hasLoadedOnce else { return }
            await loadHomeData()
            hasLoadedOnce = true
        }
        .onChange(of: dataService.lastErrorMessage) { newValue in
            showErrorAlert = (newValue != nil && !(newValue ?? "").isEmpty)
        }
        .alert("Error", isPresented: $showErrorAlert) {
            Button("OK") {
                dataService.clearLastError()
                showErrorAlert = false
            }
        } message: {
            Text(dataService.lastErrorMessage ?? "Something went wrong.")
        }
        .fullScreenCover(isPresented: $showBookAppointment) {
            BookAppointmentFlowView(userId: loggedInUser.id, dataService: dataService, onDismiss: { showBookAppointment = false })
        }
        .fullScreenCover(item: $catalogPresentation) { item in
            CatalogView(dataService: dataService, userId: loggedInUser.id, initialTab: item.openWithPromotionsSelected ? .promotions : nil, onBack: {
                catalogPresentation = nil
            })
        }
        .fullScreenCover(isPresented: $showNotifications) {
            NotificationsView(onDismiss: { showNotifications = false })
        }
        .fullScreenCover(isPresented: $showLoyaltyArchitecture) {
            LoyaltyArchitectureView(
                dataService: dataService,
                onBack: { showLoyaltyArchitecture = false },
                onContinue: { showLoyaltyArchitecture = false }
            )
        }
    }
    
    private var navigationBar: some View {
        HStack {
            Spacer()
            Button { showNotifications = true } label: {
                Image("notificationIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .frame(width: 44, height: 44)
                    .background(Color.appLightBeige)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 8)
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text("Hello, \(loggedInUser.name.isEmpty ? "Guest" : loggedInUser.name)!")
                .font(.appGreeting)
                .foregroundColor(.black)
            
            Text("How can we help you today?")
                .font(.appGreetingSubtitle)
                .foregroundColor(.appTextSecondary)
        }
    }
    
    private var loyaltyTiersSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "LOYALTY TIERS", seeAllAction: {})
            pointsBalanceCard
        }
    }
    
    private var pointsBalanceCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Total Spending")
                    .font(.custom("Poppins-Regular", size: 16))
                    .foregroundColor(.appTextSecondary)
                
                Spacer()
                
                Text(dataService.currentTier ?? "Gold Member")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.appGoldMemberText)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.appGoldMemberBg)
                    .clipShape(RoundedRectangle(cornerRadius: 43))
                    .overlay(
                        RoundedRectangle(cornerRadius: 43)
                            .stroke(Color.white.opacity(0.47), lineWidth: 1)
                    )
            }
            
            Spacer().frame(height: 3)
            
            Text("$ \(dataService.currentSpending ?? dataService.dashboardPoints ?? 0)")
                .font(.appPointsValue)
                .foregroundColor(.appAccentGold)
                .padding(.bottom, 5)
            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Tier Progress")
                            .font(.appPointsLabel)
                            .foregroundColor(.appTextSecondary)
                        
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.white)
                                    .frame(height: 6)
                                
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.appAccentGold)
                                    .frame(width: max(0, geo.size.width * tierProgressFraction), height: 6)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 6)
                        
                        Text(tierProgressSubtitle)
                            .font(.appGreetingSubtitle)
                            .foregroundColor(.appTextSecondary)
                    }
                    
                    HStack(spacing: 0) {
//                        Button(action: { openCatalogOnPromotions = false; showCatalog = true }) {
//                            Text("Redeem")
//                                .font(.system(size: 12, weight: .semibold))
//                                .foregroundColor(.appPrimaryDark)
//                                .lineLimit(1)
//                                .minimumScaleFactor(0.8)
//                                .frame(height: 28)
//                                .padding(.horizontal, 14)
//                                .background(Color.appAccentGold)
//                                .clipShape(RoundedRectangle(cornerRadius: 8))
//                        }
//                        .buttonStyle(.plain)
//                        .fixedSize(horizontal: true, vertical: false)
//                        .hidden(
                    }
                }
                Button(action: { showLoyaltyArchitecture = true }) {
                    Text("See All Tier")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .frame(height: 28)
                        .padding(.horizontal, 14)
                        .background(Color.appAccentGold)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)
                .fixedSize(horizontal: true, vertical: false)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
        .padding(.top, 15)
        .background(Color.appPrimaryDark)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var quickActionsSection: some View {
        HStack(spacing: 20) {
            quickActionCard(
                icon: "calendar",
                title: "New Appointment",
                action: { showBookAppointment = true }
            )
            .frame(maxWidth: .infinity)
            
            quickActionCard(
                icon: "square.grid.2x2",
                title: "Catalog",
                action: { catalogPresentation = CatalogPresentationItem(openWithPromotionsSelected: false) }
            )
            .frame(maxWidth: .infinity)
        }
    }
    
    private func quickActionCard(icon: String, title: String, action: @escaping () -> Void = {}) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(.appAccentGold)
                    .frame(width: 20, height: 20)
                
                Text(title)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.appTextPrimary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.appBackgroundWhite)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.appAccentGold.opacity(0.5), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
    
    private var nextAppointmentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "NEXT APPOINTMENT", seeAllAction: {})
            
            nextAppointmentCard
        }
    }
    
    private var nextAppointmentCard: some View {
        let serviceName: String
        let location: String
        let dateStr: String
        let timeStr: String
        let statusStr: String
        if let next = dataService.nextAppointment {
            serviceName = next.serviceName ?? "—"
            location = next.location ?? next.branchName ?? "—"
            dateStr = next.date ?? "—"
            timeStr = next.time ?? "—"
            statusStr = next.status ?? "Confirmed"
        } else if let first = dataService.appointments.first {
            serviceName = first.serviceName ?? "—"
            location = first.location ?? "—"
            dateStr = first.date ?? "—"
            timeStr = first.time ?? "—"
            statusStr = first.status ?? "Confirmed"
        } else {
            serviceName = "—"
            location = "—"
            dateStr = "—"
            timeStr = "—"
            statusStr = "Confirmed"
        }
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(serviceName)
                    .font(.appSectionHeader)
                    .foregroundColor(.black)
                
                Spacer()
                
                Text(statusStr)
                    .font(.appCaption)
                    .foregroundColor(.appTextPrimary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.appAccentGold)
                    .clipShape(Capsule())
            }
            
            HStack(spacing: 4) {
                Image(systemName: "mappin")
                    .font(.system(size: 12))
                    .foregroundColor(.appTextSecondary)
                Text(location)
                    .font(.appBody)
                    .foregroundColor(.appTextSecondary)
            }
            
            HStack(spacing: 16) {
                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .font(.system(size: 14))
                        .foregroundColor(.appTextPrimary)
                    Text(dateStr)
                        .font(.appBody)
                        .foregroundColor(.black)
                }
                
                HStack(spacing: 6) {
                    Image(systemName: "clock")
                        .font(.system(size: 14))
                        .foregroundColor(.appTextPrimary)
                    Text(timeStr)
                        .font(.appBody)
                        .foregroundColor(.black)
                }
            }
        }
        .padding(16)
        .background(Color.appBackgroundWhite)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.appLightBeige, lineWidth: 1)
        )
    }
    
    private var promotionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "Promotions", seeAllAction: {
                catalogPresentation = CatalogPresentationItem(openWithPromotionsSelected: true)
            })
            
            promotionCard
        }
    }
    
    private var promotionCard: some View {
        Group {
            if let url = APIConfig.imageURL(imagePath: dataService.latestPromotion?.imagePath) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        Color.appPrimaryDark
                    case .empty:
                        Color.appPrimaryDark
                            .overlay(ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white)))
                    @unknown default:
                        Color.appPrimaryDark
                    }
                }
                .frame(height: 120)
                .frame(maxWidth: .infinity)
                .clipped()
            } else {
                Color.appPrimaryDark
                    .frame(height: 120)
                    .frame(maxWidth: .infinity)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    /// Progress bar fill: (currentSpending / nextTierSpending) * 100, capped at 1.0
    private var tierProgressFraction: CGFloat {
        let cur = dataService.currentSpending ?? dataService.dashboardPoints ?? 0
        guard let next = dataService.nextTierSpending, next > 0 else {
            print("[Tier Progress] cur: \(cur), next: nil/0 → fraction: 0")
            return 0
        }
        let fraction = Double(cur) / Double(next)
        let value = min(1.0, max(0, CGFloat(fraction)))
        print("[Tier Progress] cur: \(cur), next: \(next), fraction: \(value) (\(Int(value * 100))%)")
        return value
    }
    
    private var tierProgressSubtitle: String {
        let cur = dataService.currentSpending ?? dataService.dashboardPoints ?? 0
        guard let next = dataService.nextTierSpending, next > cur else {
            return "Max tier reached"
        }
        return "Spend more  $\(next - cur) to reach next tier"
    }
    
    private func sectionHeader(title: String, seeAllAction: @escaping () -> Void) -> some View {
        HStack {
            Text(title)
                .font(.appSectionHeader)
                .foregroundColor(.black)
            
            Spacer()
            
            Button(action: seeAllAction) {
                Text("See All")
                    .font(.custom("Poppins-SemiBold", size: 10))
                    .foregroundColor(.appAccentGold)
            }
            .buttonStyle(.plain)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(loggedInUser: LoggedInUser(id: "1", name: "Yuly", email: "yuly@example.com"))
    }
}
