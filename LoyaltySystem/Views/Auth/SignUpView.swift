//
//  SignUpView.swift
//  LoyaltySystem
//
//  Sign up - circular back button, light beige inputs, blue focus border
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var showDatePicker = false
    @FocusState private var focusedField: SignUpField?
    let onSignUp: (String, String) -> Void
    let onSignIn: () -> Void
    let onBack: () -> Void
    
    enum SignUpField {
        case fullName, email, phone, password
    }
    
    var body: some View {
        ZStack {
            Color.appBackgroundWhite
                .ignoresSafeArea()
            
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
                
                ScrollView {
                    VStack(spacing: 0) {
                        Text("Sign up now")
                            .font(.appAuthTitle)
                            .foregroundColor(.appTextPrimary)
                        
                        Spacer().frame(height: 10)
                    
                    Text("Join today and start earning points.")
                        .font(.appAuthSubtitle)
                        .foregroundColor(.appTextSecondary)
                        .multilineTextAlignment(.center)
                    
                    Spacer().frame(height: 40)
                    
                    VStack(spacing: 16) {
                        SignUpTextField(placeholder: "Full Name", text: $viewModel.fullName, isFocused: focusedField == .fullName)
                            .focused($focusedField, equals: .fullName)
                        
                        SignUpTextField(placeholder: "Abc@email.com", text: $viewModel.email, isFocused: focusedField == .email)
                            .focused($focusedField, equals: .email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                        
                        SignUpTextField(placeholder: "+1 233 2342424", text: $viewModel.phone, isFocused: focusedField == .phone)
                            .focused($focusedField, equals: .phone)
                            .keyboardType(.phonePad)
                        
                        Button {
                            showDatePicker = true
                        } label: {
                            HStack {
                                Text(viewModel.hasSelectedDOB ? viewModel.dateOfBirth.formatted(date: .abbreviated, time: .omitted) : "Select Date of Birth")
                                    .foregroundColor(viewModel.hasSelectedDOB ? .appTextPrimary : .appTextSecondary)
                                Spacer()
                                Image("signUpCalenderIcon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                            }
                            .padding()
                            .background(Color.appLightBeige)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(.plain)
                        .sheet(isPresented: $showDatePicker) {
                            VStack(spacing: 0) {
                                DatePicker("Date of Birth", selection: $viewModel.dateOfBirth, displayedComponents: .date)
                                    .datePickerStyle(.graphical)
                                    .onChange(of: viewModel.dateOfBirth) { _ in
                                        viewModel.hasSelectedDOB = true
                                    }
                                Spacer()
                                Button("OK") {
                                    showDatePicker = false
                                }
                                .font(.appButton)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.appPrimaryDark)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .padding(.horizontal, 20)
                                .padding(.bottom, 24)
                            }
                            .padding()
                        }
                        
                        HStack(spacing: 12) {
                            Group {
                                if viewModel.isPasswordVisible {
                                    TextField("**********", text: $viewModel.password)
                                } else {
                                    SecureField("**********", text: $viewModel.password)
                                }
                            }
                            .textFieldStyle(.plain)
                            .focused($focusedField, equals: .password)
                            
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
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(focusedField == .password ? Color.appFocusBlue : Color.clear, lineWidth: 2)
                        )
                        
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
                    
                    Spacer().frame(height: 40)
                    
                    Button("Sign Up") {
                        Task { await viewModel.signUp() }
                        onSignUp(viewModel.email, viewModel.fullName)
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
                    
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .font(.appBody)
                            .foregroundColor(.appTextSecondary)
                        Button("Sign in") {
                            onSignIn()
                        }
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.appAccentGold)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 4)
                        .contentShape(Rectangle())
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                }
            }
            
        }
    }
}

struct SignUpTextField: View {
    let placeholder: String
    @Binding var text: String
    let isFocused: Bool
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(Color.appLightBeige)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isFocused ? Color.appFocusBlue : Color.clear, lineWidth: 2)
            )
    }
}

#Preview {
    SignUpView(onSignUp: { _, _ in }, onSignIn: {}, onBack: {})
}
