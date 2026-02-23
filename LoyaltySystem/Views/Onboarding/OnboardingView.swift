//
//  OnboardingView.swift
//  LoyaltySystem
//
//  Onboarding paginated flow using assets: calender, earnPoints, rewards
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    let onComplete: () -> Void
    let onSkip: () -> Void
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Spacer()
                    Button("Skip") {
                        viewModel.skip()
                        onSkip()
                    }
                    .font(.appCaption)
                    .foregroundColor(.appAccentGold)
                    .padding()
                }
                
                // Page content
                TabView(selection: $viewModel.currentPage) {
                    ForEach(Array(viewModel.items.enumerated()), id: \.element.id) { index, item in
                        OnboardingPageView(item: item)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Page indicators - using paagerView or simple dots
                HStack(spacing: 8) {
                    ForEach(0..<viewModel.totalPages, id: \.self) { index in
                        Circle()
                            .fill(index == viewModel.currentPage ? Color.appAccentGold : Color.appTextSecondary.opacity(0.4))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.bottom, 24)
                
                // Button
                Button(viewModel.buttonTitle) {
                    viewModel.nextPage()
                    if viewModel.hasCompletedOnboarding {
                        onComplete()
                    }
                }
                .font(.appButton)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.appPrimaryDark)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
    }
}

struct OnboardingPageView: View {
    let item: OnboardingItem
    
    var body: some View {
        VStack(spacing: 24) {
            Image(item.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 120)
            
            Text(item.title)
                .font(.appTitle)
                .foregroundColor(.appTextPrimary)
                .multilineTextAlignment(.center)
            
            Text(item.description)
                .font(.appBody)
                .foregroundColor(.appTextSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .padding(.top, 40)
    }
}

#Preview {
    OnboardingView(onComplete: {}, onSkip: {})
}
