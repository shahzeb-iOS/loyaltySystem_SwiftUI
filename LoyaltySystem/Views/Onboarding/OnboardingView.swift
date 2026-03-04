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
                
                // Pager indicator - horizontal line segments (paagerView style: active = gold, inactive = thinner gray)
                HStack(spacing: 6) {
                    ForEach(0..<viewModel.totalPages, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(index == viewModel.currentPage ? Color.appAccentGold : Color.appTextSecondary.opacity(0.25))
                            .frame(width: 28, height: index == viewModel.currentPage ? 5 : 3)
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
                .font(.appOnboardingButton)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.appPrimaryDark)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 20)
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
                .font(.appOnboardingTitle)
                .foregroundColor(.appTextPrimary)
                .multilineTextAlignment(.center)
            
            Text(item.description)
                .font(.appOnboardingSubtitle)
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
