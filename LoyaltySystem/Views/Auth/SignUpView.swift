//
//  SignUpView.swift
//  LoyaltySystem
//
//  Sign up screen with date picker and terms checkbox
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var showDatePicker = false
    let onSignUp: () -> Void
    let onSignIn: () -> Void
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    Text("Sign up now")
                        .font(.appTitle)
                        .foregroundColor(.appTextPrimary)
                    
                    Text("Join today and start earning points.")
                        .font(.appBody)
                        .foregroundColor(.appTextSecondary)
                    
                    VStack(spacing: 16) {
                        TextField("Full Name", text: $viewModel.fullName)
                            .textFieldStyle(AppTextFieldStyle())
                        
                        TextField("abc@email.com", text: $viewModel.email)
                            .textFieldStyle(AppTextFieldStyle())
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                        
                        TextField("+1 213 2342424", text: $viewModel.phone)
                            .textFieldStyle(AppTextFieldStyle())
                            .keyboardType(.phonePad)
                        
                        Button {
                            showDatePicker = true
                        } label: {
                            HStack {
                                Text(viewModel.hasSelectedDOB ? viewModel.dateOfBirth.formatted(date: .abbreviated, time: .omitted) : "Select Date of Birth")
                                    .foregroundColor(viewModel.hasSelectedDOB ? .appTextPrimary : .appTextSecondary)
                                Spacer()
                                Image("calender")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.appTextSecondary)
                            }
                            .padding()
                            .background(Color.appInputBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .sheet(isPresented: $showDatePicker) {
                            VStack {
                                DatePicker("Date of Birth", selection: $viewModel.dateOfBirth, displayedComponents: .date)
                                    .datePickerStyle(.graphical)
                                    .onChange(of: viewModel.dateOfBirth) { _, _ in
                                        viewModel.hasSelectedDOB = true
                                    }
                                Spacer()
                            }
                            .padding()
                            .presentationDetents([.medium])
                        }
                        
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
                        
                        if !viewModel.passwordHint.isEmpty {
                            Text(viewModel.passwordHint)
                                .font(.appHint)
                                .foregroundColor(.appTextSecondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        Button {
                            viewModel.agreedToTerms.toggle()
                        } label: {
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: viewModel.agreedToTerms ? "checkmark.square.fill" : "square")
                                    .foregroundColor(viewModel.agreedToTerms ? .appAccentGold : .appTextSecondary)
                                Text("I agree to the Terms of Service and Privacy Policy")
                                    .font(.appCaption)
                                    .foregroundColor(.appTextPrimary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 24)
                    
                    Button("Sign Up") {
                        Task { await viewModel.signUp() }
                        onSignUp()
                    }
                    .font(.appButton)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.appPrimaryDark)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .disabled(!viewModel.isSignUpValid)
                    .opacity(viewModel.isSignUpValid ? 1 : 0.6)
                    .padding(.horizontal, 24)
                    
                    HStack {
                        Text("Already have an account?")
                            .font(.appBody)
                            .foregroundColor(.appTextSecondary)
                        Button("Sign in") {
                            onSignIn()
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

#Preview {
    SignUpView(onSignUp: {}, onSignIn: {})
}
