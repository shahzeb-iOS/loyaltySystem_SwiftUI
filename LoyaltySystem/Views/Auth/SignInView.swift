//
//  SignInView.swift
//  LoyaltySystem
//
//  Sign in screen: siginTopIcon, light beige inputs
//

import SwiftUI

struct SignInView: View {
    @StateObject private var viewModel = AuthViewModel()
    let onSignIn: () -> Void
    let onSignUp: () -> Void
    let onForgotPassword: () -> Void

    var body: some View {
        ZStack {
            Color.appBackgroundWhite
                .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    Spacer().frame(height: 40)
                    
                    // siginTopIcon only
                    Image("siginTopIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 160, height: 160)
                        .padding(.bottom, 16)
                    
                    Text("Sign in now")
                        .font(.appAuthTitle)
                        .foregroundColor(.appAccentGold)
                    
                    Spacer().frame(height: 10)
                    
                    Text("Please sign in to continue our app")
                        .font(.appAuthSubtitle)
                        .foregroundColor(.appTextSecondary)
                        .multilineTextAlignment(.center)
                    
                    Spacer().frame(height: 40)
                    
                    VStack(spacing: 16) {
                        TextField("Enter your email", text: $viewModel.email)
                            .textFieldStyle(AuthTextFieldStyle())
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                        
                        // Password field with eye icon - tap to hide/show password
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
                        
                        HStack {
                            Spacer()
                            Button("Forget Password?") {
                                onForgotPassword()
                            }
                            .font(.appCaption)
                            .foregroundColor(.appAccentGold)
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer().frame(height: 40)
                    
                    Button("Sign In") {
                        Task { await viewModel.signIn() }
                        onSignIn()
                    }
                    .font(.appButton)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.appPrimaryDark)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .disabled(!viewModel.isSignInValid)
                    .opacity(viewModel.isSignInValid ? 1 : 0.6)
                    .padding(.horizontal, 24)
                    
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .font(.appBody)
                            .foregroundColor(.appTextSecondary)
                        Button("Sign up") {
                            onSignUp()
                        }
                        .font(.appBody)
                        .fontWeight(.medium)
                        .foregroundColor(.appAccentGold)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 4)
                        .contentShape(Rectangle())
                    }
                    .padding(.top, 30)
                    
                    Spacer().frame(height: 30)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
            }
            .scrollDismissesKeyboard(.interactively)
        }
    }
}

struct AppTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.appInputBackground)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct AuthTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.appLightBeige)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    SignInView(onSignIn: {}, onSignUp: {}, onForgotPassword: {})
}
