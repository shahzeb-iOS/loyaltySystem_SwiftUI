//
//  CatalogView.swift
//  LoyaltySystem
//
//  Catalog screen - services/products with redeem option
//

import SwiftUI

enum CatalogTab: String, CaseIterable {
    case all = "All"
    case promotions = "Promotions"
}

/// Used for push navigation to Book Appointment from catalog cell
private struct ServiceForBooking: Identifiable, Hashable {
    let id: String
    let name: String
}

struct CatalogView: View {
    @ObservedObject var dataService: DataService
    let userId: String
    let initialTab: CatalogTab?
    let onBack: () -> Void
    
    @State private var selectedTab: CatalogTab
    @State private var selectedServiceForBooking: ServiceForBooking?
    @State private var showBookFlow = false
    @State private var redeemError: String?
    @State private var showRedeemError = false
    @State private var showApiErrorAlert = false
    
    init(dataService: DataService = .shared, userId: String = "1", initialTab: CatalogTab? = nil, onBack: @escaping () -> Void) {
        self._dataService = ObservedObject(wrappedValue: dataService)
        self.userId = userId
        self.initialTab = initialTab
        self.onBack = onBack
        self._selectedTab = State(initialValue: initialTab ?? .all)
    }
    
    private var catalogItems: [CatalogItem] {
        dataService.services.map { CatalogItem.from($0) }
    }
    
    /// Sum of points from getAllServices – shown in catalog nav bar right
    private var pointsBalance: Int {
        dataService.services.reduce(0) { $0 + ($1.points ?? 0) }
    }
    
    private var isCatalogLoading: Bool {
        dataService.isLoadingDashboard || dataService.isLoadingServices || dataService.isLoadingPromotions
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                header
                segmentedControl
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 16)
                
                ZStack(alignment: .top) {
                    if isCatalogLoading {
                        LoadingOverlay()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if (selectedTab == .promotions ? dataService.promotions.isEmpty : catalogItems.isEmpty) {
                        Text("No data found")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.appTextSecondary)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollView(.vertical, showsIndicators: false) {
                            LazyVStack(spacing: 16) {
                                if selectedTab == .promotions {
                                    ForEach(Array(dataService.promotions.enumerated()), id: \.offset) { _, promo in
                                        promotionCell(promo)
                                    }
                                } else {
                                    ForEach(catalogItems) { item in
                                        catalogCard(item)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 100)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(Color.appBackgroundWhite)
            .background(
                NavigationLink(
                    destination: bookAppointmentDestination,
                    isActive: $showBookFlow
                ) { EmptyView() }
                .hidden()
            )
        }
        .navigationViewStyle(.stack)
        .task {
            dataService.clearLastError()
            await dataService.fetchAllServices()
            await dataService.fetchPromotions()
        }
        .onAppear {
            if let tab = initialTab {
                selectedTab = tab
            }
        }
        .onChange(of: dataService.lastErrorMessage) { newValue in
            showApiErrorAlert = (newValue != nil && !(newValue ?? "").isEmpty)
        }
        .alert("Error", isPresented: $showApiErrorAlert) {
            Button("OK") {
                dataService.clearLastError()
                showApiErrorAlert = false
            }
        } message: {
            Text(dataService.lastErrorMessage ?? "Something went wrong.")
        }
        .alert("Redeem Failed", isPresented: $showRedeemError) {
            Button("OK", role: .cancel) { showRedeemError = false }
        } message: {
            Text(redeemError ?? "Something went wrong.")
        }
    }
    
    private var bookAppointmentDestination: some View {
        Group {
            if let svc = selectedServiceForBooking {
                BookAppointmentFlowView(
                    userId: userId,
                    dataService: dataService,
                    onDismiss: {
                        showBookFlow = false
                        selectedServiceForBooking = nil
                    },
                    initialServiceId: svc.id,
                    initialServiceName: svc.name
                )
                .navigationBarHidden(true)
            } else {
                EmptyView()
            }
        }
    }
    
    private var filteredItems: [CatalogItem] {
        switch selectedTab {
        case .all: return catalogItems
        case .promotions: return catalogItems.filter { $0.discount != "0% off" }
        }
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
            
            Text("Catalog")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.black)
            
            Spacer()
            
            HStack(spacing: 2) {
                Text("PTS:")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.appAccentGold.opacity(0.9))
                Text("\(pointsBalance)")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.appAccentGold)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.appAccentGold.opacity(0.25))
            .clipShape(Capsule())
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 12)
    }
    
    private var segmentedControl: some View {
        HStack(spacing: 0) {
            ForEach(CatalogTab.allCases, id: \.self) { tab in
                Button {
                    selectedTab = tab
                } label: {
                    Text(tab.rawValue)
                        .font(.system(size: 14, weight: selectedTab == tab ? .bold : .regular))
                        .foregroundColor(selectedTab == tab ? .black : .appTextSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(selectedTab == tab ? Color.appBackgroundWhite : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: selectedTab == tab ? .black.opacity(0.06) : .clear, radius: 2, x: 0, y: 1)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(Color.appLightBeige)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    /// Promotions tab cell – only image (height 120, full width) from getPromotions imagePath, no redeem
    private func promotionCell(_ promo: PromotionItem) -> some View {
        Group {
            if let url = APIConfig.imageURL(imagePath: promo.imagePath) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure, .empty:
                        Color.appLightBeige
                            .overlay(ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.appAccentGold)))
                    @unknown default:
                        Color.appLightBeige
                    }
                }
            } else {
                Color.appLightBeige
            }
        }
        .frame(height: 120)
        .frame(maxWidth: .infinity)
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func catalogCard(_ item: CatalogItem) -> some View {
        HStack(alignment: .top, spacing: 16) {
            // Image (left) - base URL + imagePath, or placeholder
            ZStack {
                Color.appLightBeige
                if let url = APIConfig.imageURL(imagePath: item.imagePath) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        case .failure, .empty:
                            Image(systemName: item.imageName)
                                .font(.system(size: 28))
                                .foregroundColor(.appTextSecondary.opacity(0.5))
                        @unknown default:
                            Image(systemName: item.imageName)
                                .font(.system(size: 28))
                                .foregroundColor(.appTextSecondary.opacity(0.5))
                        }
                    }
                } else {
                    Image(systemName: item.imageName)
                        .font(.system(size: 28))
                        .foregroundColor(.appTextSecondary.opacity(0.5))
                }
            }
            .frame(width: 100, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Content (right)
            VStack(alignment: .leading, spacing: 8) {
                // Top row: discount (top right) + points (far right, aligned with title)
                HStack(alignment: .top) {
                    Text(item.discount)
                        .font(.system(size: 10, weight: .regular))
                        .foregroundColor(.appAccentGold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.appAccentGold.opacity(0.25))
                        .clipShape(Capsule())
                    
                    Spacer()
                    
                    HStack(spacing: 2) {
                        Text("\(item.points)")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.black)
                        Text("PTS")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.appTextSecondary)
                    }
                    .padding(.trailing, 7)
                }
                
                Text(item.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                
                // Duration (light grey) + Price (light orange)
                HStack(spacing: 10) {
                    if let duration = item.duration {
                        Text(duration)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.appTextSecondary)
                    }
                    Text(item.price)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.appAccentGold)
                }
                
                // Book: push Book Appointment with this cell's data; get values and print which cell was booked
                Button(action: {
                    let serviceId = "\(item.id)"
                    let serviceName = item.title
                    print("[Book] Cell booked – id: \(serviceId), title: \(serviceName), price: \(item.price), points: \(item.points), discount: \(item.discount)")
                    selectedServiceForBooking = ServiceForBooking(id: serviceId, name: serviceName)
                    showBookFlow = true
                }) {
                    HStack {
                        Text("Book")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.appPrimaryDark)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.appBackgroundWhite)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.appTextSecondary.opacity(0.08), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
    }
    
    private func redeemPoints(for item: CatalogItem) {
        Task {
            do {
                try await dataService.redeemPoints(userId: userId, points: item.points)
            } catch {
                await MainActor.run {
                    redeemError = error.localizedDescription
                    showRedeemError = true
                }
            }
        }
    }
    
}

struct CatalogView_Previews: PreviewProvider {
    static var previews: some View {
        CatalogView(dataService: .shared, userId: "1", onBack: {})
    }
}
