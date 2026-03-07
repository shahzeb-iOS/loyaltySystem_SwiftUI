//
//  ForgotPasswordView.swift
//  LoyaltySystem
//
//  Forgot password - enter email to reset
//

import SwiftUI

struct ForgotPasswordView: View {
    @StateObject private var viewModel = AuthViewModel()
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
                    
                    Spacer().frame(height: 20)
                    
                    Text("Forgot password")
                        .font(.appAuthTitle)
                        .foregroundColor(.appPrimaryDark)
                    
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
                    
                    Spacer().frame(height: 40)
                    
                    Button("Reset Password") {
                        onResetSent(viewModel.email)
                    }
                    .font(.appButton)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.appPrimaryDark)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .disabled(viewModel.email.isEmpty)
                    .opacity(viewModel.email.isEmpty ? 0.6 : 1)
                    .padding(.horizontal, 24)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
            }
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView(onBack: {}, onResetSent: { _ in })
    }
}
