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
    case forgotPassword
    case checkEmail
    case otpVerification
    case setNewPassword
    case main
}

@MainActor
final class AppFlowViewModel: ObservableObject {
    
    @Published var currentScreen: AppScreen = .splash
    @Published var showSplash: Bool = true
    @Published var forgotPasswordEmail: String = ""
    @Published var otpEmail: String = ""
    @Published var otpFromForgotPassword: Bool = false
    
    func handleSplashComplete() {
        withAnimation {
            showSplash = false
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
    
    func navigateToForgotPassword() {
        currentScreen = .forgotPassword
    }
    
    func navigateToCheckEmail(email: String) {
        forgotPasswordEmail = email
        currentScreen = .checkEmail
    }
    
    func navigateToOTPVerification(email: String, fromForgotPassword: Bool = false) {
        otpEmail = email
        otpFromForgotPassword = fromForgotPassword
        currentScreen = .otpVerification
    }

    func navigateBackFromOTP() {
        if otpFromForgotPassword {
            navigateBackToForgotPassword()
        } else {
            navigateToSignIn()
        }
    }

    func navigateToSetNewPassword() {
        currentScreen = .setNewPassword
    }

    func navigateBackToOTP() {
        currentScreen = .otpVerification
    }
    
    func navigateBackToSignIn() {
        currentScreen = .signIn
    }
    
    func navigateBackToForgotPassword() {
        currentScreen = .forgotPassword
    }

    func handleAuthSuccess() {
        currentScreen = .main
    }
}
