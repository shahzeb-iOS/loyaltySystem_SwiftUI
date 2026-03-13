//
//  ForgotPasswordView.swift
//  LoyaltySystem
//
//  Forgot password - enter email to reset
//

import SwiftUI

struct ForgotPasswordView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var isSendingOTP = false
    @State private var sendOTPError: String?
    let onBack: () -> Void
    let onResetSent: (String) -> Void
    
    var body: some View {
        ZStack {
            Color.appBackgroundWhite
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    HStack {
                        Button { onBack() } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.appAccentGold)
                                .frame(width: 44, height: 44)
                                .background(Color.appLightBeige)
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 8)
                    
                    Text("Forgot password")
                        .font(.appAuthTitle)
                        .foregroundColor(.appPrimaryDark)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 20)
                    
                    Spacer().frame(height: 10)
                    
                    Text("Enter your email account to reset your password")
                        .font(.appAuthSubtitle)
                        .foregroundColor(.appTextSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 60)
                    
                    Spacer().frame(height: 40)
                    
                    TextField("Enter your email", text: Binding(
                        get: { viewModel.email },
                        set: { viewModel.email = String($0.prefix(100)) }
                    ))
                        .textFieldStyle(AuthTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .padding(.horizontal, 24)
                    
                    if let err = sendOTPError {
                        Text(err)
                            .font(.appHint)
                            .foregroundColor(.appErrorText)
                            .padding(.horizontal, 24)
                    }
                    
                    Spacer().frame(height: 40)
                    
                    Button("Reset Password") {
                        sendOTPError = nil
                        Task { await sendOTP() }
                    }
                    .font(.appButton)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.appPrimaryDark)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .disabled(viewModel.email.isEmpty || isSendingOTP)
                    .opacity(viewModel.email.isEmpty || isSendingOTP ? 0.6 : 1)
                    .padding(.horizontal, 24)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
            }
            
            if isSendingOTP {
                LoadingOverlay()
                    .ignoresSafeArea()
            }
        }
        .navigationBarHidden(true)
    }
    
    private func sendOTP() async {
        isSendingOTP = true
        defer { isSendingOTP = false }
        let endpoint = APIEndpoint.sendOTP(email: viewModel.email)
        do {
            let response: MessageResponse = try await APIService.shared.request(endpoint)
            let ok = response.success ?? response.status ?? false
            let msg = (response.message ?? "").lowercased()
            if ok || msg.contains("success") {
                await MainActor.run { onResetSent(viewModel.email) }
            } else {
                await MainActor.run { sendOTPError = response.message ?? "Failed to send OTP" }
            }
        } catch {
            await MainActor.run { sendOTPError = error.localizedDescription }
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView(onBack: {}, onResetSent: { _ in })
    }
}
