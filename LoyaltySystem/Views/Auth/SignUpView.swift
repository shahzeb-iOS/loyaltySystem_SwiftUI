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
    @State private var showErrorAlert = false
    @State private var showSuccessAlert = false
    @FocusState private var focusedField: SignUpField?
    let onSignUp: (String, String) -> Void
    let onSignIn: () -> Void
    let onBack: () -> Void
    
    enum SignUpField {
        case fullName, email, phone, password
    }
    
    var body: some View {
        mainContent
            .overlay(datePickerOverlay)
            .onChange(of: viewModel.errorMessage) { newValue in
                showErrorAlert = (newValue != nil && !(newValue ?? "").isEmpty)
            }
            .alert("Sign Up Failed", isPresented: $showErrorAlert) {
                Button("OK") {
                    showErrorAlert = false
                    viewModel.errorMessage = nil
                }
            } message: {
                Text(viewModel.errorMessage ?? "Something went wrong")
            }
            .alert("Account Created", isPresented: $showSuccessAlert) {
                Button("OK") {
                    showSuccessAlert = false
                    onSignIn()
                }
            } message: {
                Text("Account created successfully. Please sign in.")
            }
            .overlay(loadingOverlay)
    }
    
    private var mainContent: some View {
        ZStack {
            Color.appBackgroundWhite
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                ScrollView {
                    signUpForm
                }
            }
        }
    }
    
    private var headerView: some View {
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
    }
    
    @ViewBuilder
    private var signUpForm: some View {
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
            
            formFields
            
            Spacer().frame(height: 40)
            
            signUpButton
            
            signInLink
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
    }
    
    @ViewBuilder
    private var formFields: some View {
        VStack(spacing: 16) {
            fullNameField
            emailField
            phoneField
            dateOfBirthButton
            passwordField
            passwordHintView
            termsButton
        }
        .padding(.horizontal, 24)
    }
    
    @ViewBuilder
    private var fullNameField: some View {
        VStack(alignment: .leading, spacing: 4) {
            SignUpTextField(placeholder: "Full Name", text: Binding(
                get: { viewModel.fullName },
                set: { viewModel.fullName = String($0.prefix(12)) }
            ), isFocused: focusedField == .fullName)
                .focused($focusedField, equals: .fullName)
                .onChange(of: viewModel.fullName) { newValue in
                    if newValue.count > 12 {
                        viewModel.fullName = String(newValue.prefix(12))
                    }
                }
            if !viewModel.fullNameHint.isEmpty {
                Text(viewModel.fullNameHint)
                    .font(.appHint)
                    .foregroundColor(.appErrorText)
            }
        }
    }
    
    @ViewBuilder
    private var emailField: some View {
        VStack(alignment: .leading, spacing: 4) {
            SignUpTextField(placeholder: "Abc@email.com", text: Binding(
                get: { viewModel.email },
                set: { viewModel.email = String($0.prefix(100)) }
            ), isFocused: focusedField == .email)
                .focused($focusedField, equals: .email)
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
    }
    
    @ViewBuilder
    private var phoneField: some View {
        VStack(alignment: .leading, spacing: 4) {
            SignUpTextField(placeholder: "+1 233 2342424", text: Binding(
                get: { viewModel.phone },
                set: { viewModel.phone = String($0.prefix(18)) }
            ), isFocused: focusedField == .phone)
                .focused($focusedField, equals: .phone)
                .keyboardType(.phonePad)
                .onChange(of: viewModel.phone) { newValue in
                    if newValue.count > 18 { viewModel.phone = String(newValue.prefix(18)) }
                }
            if !viewModel.phoneHint.isEmpty {
                Text(viewModel.phoneHint)
                    .font(.appHint)
                    .foregroundColor(.appErrorText)
            }
        }
    }
    
    private var dateOfBirthButton: some View {
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
    }
    
    private var passwordField: some View {
        let passwordBinding = Binding(
            get: { viewModel.password },
            set: { viewModel.password = String($0.prefix(15)) }
        )
        return HStack(spacing: 12) {
            Group {
                if viewModel.isPasswordVisible {
                    TextField("**********", text: passwordBinding)
                } else {
                    SecureField("**********", text: passwordBinding)
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
                .stroke(focusedField == .password ? Color.appFocusBorder : Color.clear, lineWidth: 2)
        )
        .onChange(of: viewModel.password) { newValue in
            if newValue.count > 15 { viewModel.password = String(newValue.prefix(15)) }
        }
    }
    
    @ViewBuilder
    private var passwordHintView: some View {
        if !viewModel.passwordHint.isEmpty {
            Text(viewModel.passwordHint)
                .font(.appHint)
                .foregroundColor(.appErrorText)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var termsButton: some View {
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
    
    private var signUpButton: some View {
        Button("Sign Up") {
            Task {
                await viewModel.signUp()
                if viewModel.signUpSuccess {
                    showSuccessAlert = true
                }
            }
        }
        .font(.appButton)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.appPrimaryDark)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .disabled(!viewModel.isSignUpValid || viewModel.isLoading)
        .opacity(viewModel.isSignUpValid && !viewModel.isLoading ? 1 : 0.6)
        .padding(.horizontal, 24)
    }
    
    private var signInLink: some View {
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
    
    @ViewBuilder
    private var datePickerOverlay: some View {
        if showDatePicker {
            ZStack(alignment: .top) {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture { showDatePicker = false }
                
                CustomCalendarOverlay(
                    selectedDate: $viewModel.dateOfBirth,
                    hasSelectedDate: $viewModel.hasSelectedDOB,
                    onDismiss: { showDatePicker = false }
                )
                .padding(.top, 200)
                .padding(.horizontal, 20)
            }
        }
    }
    
    @ViewBuilder
    private var loadingOverlay: some View {
        if viewModel.isLoading {
            LoadingOverlay()
                .zIndex(999)
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
                    .stroke(isFocused ? Color.appFocusBorder : Color.clear, lineWidth: 2)
            )
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(onSignUp: { _, _ in }, onSignIn: {}, onBack: {})
    }
}
