//
//  AppFlowViewModel.swift
//  LoyaltySystem
//
//  ViewModel coordinating app navigation flow: Splash -> Onboarding -> Auth -> Main
//

import Foundation
import SwiftUI

enum AppScreen {
    case splash
    case onboarding
    case signIn
    case signUp
    case main
}

@MainActor
final class AppFlowViewModel: ObservableObject {
    
    @Published var currentScreen: AppScreen = .splash
    @Published var showSplash: Bool = true
    
    func handleSplashComplete() {
        withAnimation {
            showSplash = false
            // TODO: Check UserDefaults for hasSeenOnboarding, isLoggedIn
            currentScreen = .onboarding
        }
    }
    
    func handleOnboardingComplete() {
        currentScreen = .signIn
    }
    
    func navigateToSignUp() {
        currentScreen = .signUp
    }
    
    func navigateToSignIn() {
        currentScreen = .signIn
    }
    
    func handleAuthSuccess() {
        currentScreen = .main
    }
}
