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

struct CatalogView: View {
    @ObservedObject var dataService: DataService
    let onBack: () -> Void
    
    @State private var selectedTab: CatalogTab = .all
    
    init(dataService: DataService = .shared, onBack: @escaping () -> Void) {
        self._dataService = ObservedObject(wrappedValue: dataService)
        self.onBack = onBack
    }
    
    private var catalogItems: [CatalogItem] {
        let serviceItems = dataService.services.map { CatalogItem.from($0) }
        let items = serviceItems.isEmpty ? fallbackItems : serviceItems
        return items
    }
    
    private var fallbackItems: [CatalogItem] {
        [
            CatalogItem(title: "Hydra Facial", duration: "30 Min", price: "$40", points: 50, discount: "50% off", imageName: "face.smiling"),
            CatalogItem(title: "Skin care kit", duration: nil, price: "$40", points: 100, discount: "10% off", imageName: "gift.fill"),
            CatalogItem(title: "Classic Facial", duration: "30 Min", price: "$40", points: 200, discount: "50% off", imageName: "sparkles")
        ]
    }
    
    private let pointsBalance = 1250
    
    var body: some View {
        VStack(spacing: 0) {
            header
            segmentedControl
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 16)
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 16) {
                    ForEach(filteredItems) { item in
                        catalogCard(item)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
        .background(Color.appBackgroundWhite)
        .task {
            await dataService.fetchAllServices()
            await dataService.fetchPromotions()
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
    
    private func catalogCard(_ item: CatalogItem) -> some View {
        HStack(alignment: .top, spacing: 16) {
            // Image (left) - ~1/3 card width, rounded square
            ZStack {
                Color.appLightBeige
                Image(systemName: item.imageName)
                    .font(.system(size: 28))
                    .foregroundColor(.appTextSecondary.opacity(0.5))
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
                
                // Redeem button
                Button(action: {}) {
                    Text("Redeem")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.white)
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
}

struct CatalogView_Previews: PreviewProvider {
    static var previews: some View {
        CatalogView(dataService: .shared, onBack: {})
    }
}
