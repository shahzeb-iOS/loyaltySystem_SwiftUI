//
//  RootView.swift
//  LoyaltySystem
//
//  Root view coordinating app flow with MVVM
//

import SwiftUI

struct RootView: View {
    @StateObject private var flowViewModel = AppFlowViewModel()
    
    var body: some View {
        ZStack {
            switch flowViewModel.currentScreen {
            case .splash:
                SplashView(onComplete: flowViewModel.handleSplashComplete)
            case .onboarding:
                OnboardingView(
                    onComplete: flowViewModel.handleOnboardingComplete,
                    onSkip: flowViewModel.handleOnboardingComplete
                )
            case .signIn:
                SignInView(
                    onSignIn: flowViewModel.handleAuthSuccess,
                    onSignUp: flowViewModel.navigateToSignUp
                )
                .overlay(alignment: .topLeading) {
                    Button {
                        flowViewModel.currentScreen = .onboarding
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.appTextPrimary)
                            .padding()
                    }
                }
            case .signUp:
                SignUpView(
                    onSignUp: flowViewModel.handleAuthSuccess,
                    onSignIn: flowViewModel.navigateToSignIn
                )
                .overlay(alignment: .topLeading) {
                    Button {
                        flowViewModel.navigateToSignIn()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.appTextPrimary)
                            .padding()
                    }
                }
            case .main:
                MainPlaceholderView()
            }
        }
    }
}

struct MainPlaceholderView: View {
    var body: some View {
        Color.appBackground
            .overlay(
                Text("Dashboard")
                    .font(.appTitle)
                    .foregroundColor(.appTextPrimary)
            )
    }
}

#Preview {
    RootView()
}
