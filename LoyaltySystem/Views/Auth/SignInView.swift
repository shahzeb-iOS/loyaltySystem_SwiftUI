//
//  SignInView.swift
//  LoyaltySystem
//
//  Sign in screen: siginTopIcon, light beige inputs
//

import SwiftUI

struct SignInView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var showErrorAlert = false
    let onSignIn: (LoggedInUser) -> Void
    let onSignUp: () -> Void
    let onForgotPassword: () -> Void

    var body: some View {
        content
            .onChange(of: viewModel.errorMessage) { newValue in
                showErrorAlert = (newValue != nil && !(newValue ?? "").isEmpty)
            }
            .alert("Login Failed", isPresented: $showErrorAlert) {
                Button("OK") {
                    showErrorAlert = false
                    viewModel.errorMessage = nil
                }
            } message: {
                Text(viewModel.errorMessage ?? "Invalid credentials")
            }
    }
    
    private var content: some View {
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
                        VStack(alignment: .leading, spacing: 4) {
                            TextField("Enter your email", text: Binding(
                                get: { viewModel.email },
                                set: { viewModel.email = String($0.prefix(100)) }
                            ))
                                .textFieldStyle(AuthTextFieldStyle())
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                            if !viewModel.email.isEmpty && !viewModel.isValidEmail {
                                Text("Please enter a valid email")
                                    .font(.appHint)
                                    .foregroundColor(.appErrorText)
                            }
                        }
                        .onChange(of: viewModel.email) { newValue in
                            if newValue.count > 100 { viewModel.email = String(newValue.prefix(100)) }
                        }
                        
                        // Password field with eye icon - tap to hide/show password
                        HStack(spacing: 12) {
                            Group {
                                if viewModel.isPasswordVisible {
                                    TextField("Enter your password", text: Binding(
                                        get: { viewModel.password },
                                        set: { viewModel.password = String($0.prefix(15)) }
                                    ))
                                } else {
                                    SecureField("Enter your password", text: Binding(
                                        get: { viewModel.password },
                                        set: { viewModel.password = String($0.prefix(15)) }
                                    ))
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
                        .onChange(of: viewModel.password) { newValue in
                            if newValue.count > 15 { viewModel.password = String(newValue.prefix(15)) }
                        }
                        
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
                        Task {
                            await viewModel.signIn()
                            if viewModel.signInSuccess {
                                let user = LoggedInUser(from: viewModel.userDataFromAPI)
                                    ?? LoggedInUser(id: viewModel.userIdFromAPI ?? "1", name: viewModel.userNameFromAPI ?? viewModel.email.split(separator: "@").first.map { String($0).capitalized } ?? "", email: viewModel.email)
                                onSignIn(user)
                            }
                        }
                    }
                    .font(.appButton)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.appPrimaryDark)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .disabled(!viewModel.isSignInValid || viewModel.isLoading)
                    .opacity(viewModel.isSignInValid && !viewModel.isLoading ? 1 : 0.6)
                    .padding(.horizontal, 24)
                    
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .font(.appBody)
                            .foregroundColor(.appTextSecondary)
                        Button("Sign up") {
                            onSignUp()
                        }
                        .font(.system(size: 16, weight: .medium))
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
            
            if viewModel.isLoading {
                LoadingOverlay()
                    .zIndex(999)
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

struct AuthTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.appLightBeige)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(onSignIn: { _ in }, onSignUp: {}, onForgotPassword: {})
    }
}
