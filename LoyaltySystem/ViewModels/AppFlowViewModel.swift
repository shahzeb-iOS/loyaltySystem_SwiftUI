//
//  AppFlowViewModel.swift
//  LoyaltySystem
//
//  ViewModel coordinating app navigation flow: Splash -> Onboarding (once) -> Auth -> Main
//

import Foundation
import SwiftUI

private let hasCompletedOnboardingKey = "hasCompletedOnboarding"

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
    @Published var otpFullName: String = ""
    @Published var otpUserId: Int = 5
    @Published var otpFromForgotPassword: Bool = false
    @Published var loggedInUser: LoggedInUser?
    
    func handleSplashComplete() {
        withAnimation {
            showSplash = false
            // Onboarding sirf pehli baar (first install) dikhao; baad mein seedha sign-in
            if UserDefaults.standard.bool(forKey: hasCompletedOnboardingKey) {
                currentScreen = .signIn
            } else {
                currentScreen = .onboarding
            }
        }
    }

    func handleOnboardingComplete() {
        UserDefaults.standard.set(true, forKey: hasCompletedOnboardingKey)
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
    
    func navigateToOTPVerification(email: String, fullName: String = "", fromForgotPassword: Bool = false) {
        otpEmail = email
        otpFullName = fullName
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

    func handleAuthSuccess(user: LoggedInUser? = nil) {
        if let u = user {
            loggedInUser = u
        } else if !otpFullName.isEmpty || !otpEmail.isEmpty {
            loggedInUser = LoggedInUser(id: "1", name: otpFullName, email: otpEmail)
        }
        currentScreen = .main
    }
    
    func logout() {
        loggedInUser = nil
        currentScreen = .signIn
    }
}
