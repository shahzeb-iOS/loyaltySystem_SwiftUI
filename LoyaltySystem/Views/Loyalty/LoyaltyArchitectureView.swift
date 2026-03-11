//
//  LoyaltyArchitectureView.swift
//  LoyaltySystem
//
//  Loyalty tier detail - PLUS tier with member privileges
//

import SwiftUI

struct LoyaltyArchitectureView: View {
    @ObservedObject var dataService: DataService
    let onBack: () -> Void
    let onContinue: () -> Void
    @State private var showErrorAlert = false
    
    private let privileges = [
        "1 complimentary facial analysis",
        "1 complimentary facial or body consultation",
        "Preferred pricing on new treatment launches",
        "Personalized birthday greeting",
        "Complimentary birthday facial 🎂✨"
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            header
            
            ZStack(alignment: .top) {
                if dataService.isLoadingTiers {
                    SpinnerOverlayView(tint: Color.appPrimaryDark)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if dataService.tiers.isEmpty {
                    Text("No data found")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.appTextSecondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            tiersFromAPISection
                            tierCard
                            privilegesSection
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .padding(.bottom, 100)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            continueButton
        }
        .background(Color.appBackgroundWhite)
        .task {
            dataService.clearLastError()
            await dataService.fetchTiers()
        }
        .onAppear {
            if dataService.tiers.isEmpty && !dataService.isLoadingTiers {
                Task { await dataService.fetchTiers() }
            }
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
    
    private var tiersFromAPISection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tiers")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
            ForEach(Array(dataService.tiers.enumerated()), id: \.offset) { _, tier in
                tierCardFromAPI(tier)
            }
        }
        .padding(.bottom, 24)
    }
    
    private func tierCardFromAPI(_ tier: TierItem) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(tier.name ?? "Tier")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                if let pts = tier.pointsRequired {
                    Text("\(pts) PTS")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.appAccentGold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.appAccentGold.opacity(0.25))
                        .clipShape(Capsule())
                }
                Spacer()
            }
            if let desc = tier.description, !desc.isEmpty {
                Text(desc)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.appTextSecondary)
            }
            if let benefits = tier.benefits, !benefits.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(benefits, id: \.self) { b in
                        Text("• \(b)")
                            .font(.system(size: 11, weight: .regular))
                            .foregroundColor(.appTextSecondary)
                    }
                }
            }
        }
        .padding(16)
        .background(Color.appBackgroundWhite)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.appTextSecondary.opacity(0.08), lineWidth: 1)
        )
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
    
    private var tierCard: some View {
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
                Text("✨ PLUS")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Entry Level")
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
        .padding(.bottom, 24)
    }
    
    private var privilegesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Member Privileges")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.appTextSecondary)
            
            VStack(spacing: 12) {
                ForEach(privileges, id: \.self) { privilege in
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
    
    private var continueButton: some View {
        Button(action: onContinue) {
            Text("Continue")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.appPrimaryDark)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
        .background(Color.appBackgroundWhite)
    }
}

struct LoyaltyArchitectureView_Previews: PreviewProvider {
    static var previews: some View {
        LoyaltyArchitectureView(dataService: .shared, onBack: {}, onContinue: {})
    }
}
