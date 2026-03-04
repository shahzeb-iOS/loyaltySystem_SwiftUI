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
            Color.appBackgroundWhite
                .ignoresSafeArea()
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
                    onSignUp: flowViewModel.navigateToSignUp,
                    onForgotPassword: flowViewModel.navigateToForgotPassword
                )
            case .signUp:
                SignUpView(
                    onSignUp: { email in flowViewModel.navigateToOTPVerification(email: email) },
                    onSignIn: flowViewModel.navigateToSignIn,
                    onBack: flowViewModel.navigateToSignIn
                )
            case .forgotPassword:
                ForgotPasswordView(
                    onBack: flowViewModel.navigateBackToSignIn,
                    onResetSent: { email in flowViewModel.navigateToOTPVerification(email: email, fromForgotPassword: true) }
                )
            case .checkEmail:
                CheckEmailView(
                    email: flowViewModel.forgotPasswordEmail,
                    onDismiss: flowViewModel.navigateBackToForgotPassword
                )
            case .otpVerification:
                OTPVerificationView(
                    email: flowViewModel.otpEmail.isEmpty ? "adnan@gmail.com" : flowViewModel.otpEmail,
                    onBack: { flowViewModel.navigateBackFromOTP() },
                    onVerified: { flowViewModel.otpFromForgotPassword ? flowViewModel.navigateToSetNewPassword() : flowViewModel.handleAuthSuccess() }
                )
            case .setNewPassword:
                SetNewPasswordView(
                    onBack: flowViewModel.navigateBackToOTP,
                    onResetComplete: flowViewModel.navigateBackToSignIn
                )
            case .main:
                MainPlaceholderView()
            }
        }
        .hideKeyboardOnTap()
    }
}

struct MainPlaceholderView: View {
    var body: some View {
        Color.appBackgroundWhite
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
