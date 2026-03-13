//
//  LoyaltyArchitectureView.swift
//  LoyaltySystem
//
//  getTiers list – har tier ke liye 1 cell (poora design: dark card + Member Privileges)
//

import SwiftUI

struct LoyaltyArchitectureView: View {
    @ObservedObject var dataService: DataService
    let onBack: () -> Void
    let onContinue: () -> Void
    @State private var showErrorAlert = false
    @State private var selectedPage = 0
    
    var body: some View {
        VStack(spacing: 0) {
            header
            
            ZStack(alignment: .top) {
                if dataService.isLoadingTiers {
                    LoadingOverlay()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if dataService.tiers.isEmpty {
                    Text("No tiers found")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.appTextSecondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    TabView(selection: $selectedPage) {
                        ForEach(Array(dataService.tiers.enumerated()), id: \.offset) { index, tier in
                            ScrollView(.vertical, showsIndicators: false) {
                                tierCell(tier)
                                    .padding(.horizontal, 20)
                                    .padding(.top, 24)
                                    .padding(.bottom, 80)
                            }
                            .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            if !dataService.isLoadingTiers && !dataService.tiers.isEmpty {
                pagerView
            }
        }
        .background(Color.appBackgroundWhite)
        .task {
            dataService.clearLastError()
            await dataService.fetchTiers()
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
    }
    
    /// 1 cell = poora design (dark card + Member Privileges) us tier ke data se
    private func tierCell(_ tier: TierItem) -> some View {
        VStack(spacing: 0) {
            tierCardView(tier)
            privilegesSection(tier)
        }
    }
    
    private func tierCardView(_ tier: TierItem) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 56, height: 56)
                    Image("frame")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                        .foregroundColor(.white)
                }
                .frame(width: 56, height: 56)
                Spacer()
                Text("Status Tier")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
            }
            VStack(alignment: .leading, spacing: 8) {
                Text(tier.title ?? "—")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                Text(tier.tierDescription ?? "Entry Level")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.95))
                Text("Where your journey to excellence begins.")
                    .font(.system(size: 14, weight: .regular))
                    .italic()
                    .foregroundColor(.white.opacity(0.9))
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.appPrimaryDark)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func privilegesSection(_ tier: TierItem) -> some View {
        let items = tier.tierBenefits ?? tier.benefits ?? []
        return VStack(alignment: .leading, spacing: 16) {
            Text("Member Privileges")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.appTextSecondary)
            VStack(spacing: 12) {
                ForEach(items, id: \.self) { privilege in
                    HStack(alignment: .top, spacing: 12) {
                        ZStack {
                            Circle()
                                .stroke(Color.appAccentGold, lineWidth: 1.5)
                                .frame(width: 24, height: 24)
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.appAccentGold)
                        }
                        Text(privilege)
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.appTextPrimary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.appLightBeige)
        .clipShape(RoundedRectangle(cornerRadius: 16))
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
            
            Text("Loyalty Architecture")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.black)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 12)
    }
    
    private var pagerView: some View {
        HStack(spacing: 6) {
            ForEach(Array(dataService.tiers.enumerated()), id: \.offset) { index, _ in
                Circle()
                    .fill(index == selectedPage ? Color.appPrimaryDark : Color.appTextSecondary.opacity(0.3))
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
    }
}

struct LoyaltyArchitectureView_Previews: PreviewProvider {
    static var previews: some View {
        LoyaltyArchitectureView(dataService: .shared, onBack: {}, onContinue: {})
    }
}
