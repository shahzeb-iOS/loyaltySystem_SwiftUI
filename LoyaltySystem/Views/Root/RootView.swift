//
//  RootView.swift
//  LoyaltySystem
//
//  Root view coordinating app flow with MVVM
//

import SwiftUI

struct RootView: View {
    @StateObject private var flowViewModel = AppFlowViewModel()
    @State private var showForgotPasswordPush = false
    
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
                NavigationView {
                    SignInView(
                        onSignIn: { user in flowViewModel.handleAuthSuccess(user: user) },
                        onSignUp: flowViewModel.navigateToSignUp,
                        onForgotPassword: { showForgotPasswordPush = true }
                    )
                    .background(
                        NavigationLink(
                            destination: ForgotPasswordView(
                                onBack: { showForgotPasswordPush = false },
                                onResetSent: { email in
                                    flowViewModel.navigateToOTPVerification(email: email, fromForgotPassword: true)
                                    showForgotPasswordPush = false
                                }
                            )
                            .navigationBarHidden(true),
                            isActive: $showForgotPasswordPush
                        ) { EmptyView() }
                        .hidden()
                    )
                    .navigationBarHidden(true)
                }
                .navigationViewStyle(.stack)
            case .signUp:
                SignUpView(
                    onSignUp: { email, fullName in flowViewModel.navigateToOTPVerification(email: email, fullName: fullName) },
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
                    userId: flowViewModel.otpUserId,
                    onBack: flowViewModel.navigateBackToOTP,
                    onResetComplete: flowViewModel.navigateBackToSignIn
                )
            case .main:
                MainTabView(
                    loggedInUser: flowViewModel.loggedInUser ?? LoggedInUser(id: "1", name: "Guest", email: ""),
                    onLogout: flowViewModel.logout
                )
            }
        }
        .hideKeyboardOnTap()
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
