//
//  SignInView.swift
//  LoyaltySystem
//
//  Sign in screen using eyeIcon from assets
//

import SwiftUI

struct SignInView: View {
    @StateObject private var viewModel = AuthViewModel()
    let onSignIn: () -> Void
    let onSignUp: () -> Void
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Logo placeholder
                    Image(systemName: "sparkles")
                        .font(.system(size: 48))
                        .foregroundColor(.appPrimaryDark)
                    
                    Text("Sign in now")
                        .font(.appTitle)
                        .foregroundColor(.appTextPrimary)
                    
                    Text("Please sign in to continue our app")
                        .font(.appSubtitle)
                        .foregroundColor(.appAccentGold)
                    
                    VStack(spacing: 16) {
                        TextField("obc@gmail.com", text: $viewModel.email)
                            .textFieldStyle(AppTextFieldStyle())
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                        
                        HStack {
                            if viewModel.isPasswordVisible {
                                TextField("*******", text: $viewModel.password)
                                    .textFieldStyle(AppTextFieldStyle())
                            } else {
                                SecureField("*******", text: $viewModel.password)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            Button {
                                viewModel.isPasswordVisible.toggle()
                            } label: {
                                Image("eyeIcon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.appTextSecondary)
                            }
                        }
                        
                        HStack {
                            Spacer()
                            Button("Forgot Password?") { }
                                .font(.appCaption)
                                .foregroundColor(.appAccentGold)
                        }
                    }
                    .padding(.horizontal, 24)
                    
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
                    
                    HStack {
                        Text("Don't have an account?")
                            .font(.appBody)
                            .foregroundColor(.appTextSecondary)
                        Button("Sign up") {
                            onSignUp()
                        }
                        .font(.appBody)
                        .foregroundColor(.appAccentGold)
                    }
                }
                .padding(.vertical, 32)
            }
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

#Preview {
    SignInView(onSignIn: {}, onSignUp: {})
}
