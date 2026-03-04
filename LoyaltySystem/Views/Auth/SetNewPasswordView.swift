//
//  SetNewPasswordView.swift
//  LoyaltySystem
//
//  Set new password - single password field with eye icon
//

import SwiftUI

struct SetNewPasswordView: View {
    @StateObject private var viewModel = AuthViewModel()
    let onBack: () -> Void
    let onResetComplete: () -> Void
    
    var body: some View {
        ZStack {
            Color.appBackgroundWhite
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
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
                    
                    Text("Set New Password")
                        .font(.appAuthTitle)
                        .foregroundColor(.appTextPrimary)
                    
                    Text("Enter Your New Password")
                        .font(.appAuthSubtitle)
                        .foregroundColor(.appTextSecondary)
                    
                    // Password field with eye icon
                    HStack(spacing: 12) {
                        Group {
                            if viewModel.isPasswordVisible {
                                TextField("Enter your password", text: $viewModel.password)
                            } else {
                                SecureField("Enter your password", text: $viewModel.password)
                            }
                        }
                        .textFieldStyle(.plain)
                        
                        Button {
                            viewModel.isPasswordVisible.toggle()
                        } label: {
                            Image(systemName: viewModel.isPasswordVisible ? "eye.slash" : "eye")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.appAccentGold)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    .background(Color.appLightBeige)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal, 24)
                    
                    Button("Reset Password") {
                        onResetComplete()
                    }
                    .font(.appButton)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.appPrimaryDark)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .disabled(viewModel.password.count < 8)
                    .opacity(viewModel.password.count >= 8 ? 1 : 0.6)
                    .padding(.horizontal, 24)
                }
                .padding(.vertical, 24)
            }
        }
    }
}

#Preview {
    SetNewPasswordView(onBack: {}, onResetComplete: {})
}
