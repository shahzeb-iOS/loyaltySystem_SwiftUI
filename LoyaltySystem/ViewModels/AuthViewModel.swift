//
//  AuthViewModel.swift
//  LoyaltySystem
//
//  ViewModel for Sign In / Sign Up flow
//

import Foundation
import SwiftUI

@MainActor
final class AuthViewModel: ObservableObject {
    
    // MARK: - Sign In
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isPasswordVisible: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var signInSuccess: Bool = false
    @Published var userNameFromAPI: String?
    
    // MARK: - Sign Up
    @Published var fullName: String = ""
    @Published var phone: String = ""
    @Published var dateOfBirth: Date = .now
    @Published var hasSelectedDOB: Bool = false
    @Published var agreedToTerms: Bool = false
    @Published var signUpSuccess: Bool = false
    
    // MARK: - Validation
    private static let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
    
    var isValidEmail: Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", Self.emailRegex)
        return predicate.evaluate(with: email)
    }
    
    var isSignInValid: Bool {
        isValidEmail && !password.isEmpty && password.count >= 5 && password.count <= 15
    }
    
    var isSignUpValid: Bool {
        fullName.count >= 4 && fullName.count <= 20 &&
        isValidEmail &&
        phone.count >= 4 && phone.count <= 15 &&
        hasSelectedDOB &&
        password.count >= 5 && password.count <= 15 &&
        agreedToTerms
    }
    
    var fullNameHint: String {
        if fullName.isEmpty { return "" }
        if fullName.count < 4 { return "Name must be at least 4 characters" }
        if fullName.count > 20 { return "Name must be at most 20 characters" }
        return ""
    }
    
    var phoneHint: String {
        if phone.isEmpty { return "" }
        if phone.count < 4 { return "Phone must be at least 4 characters" }
        if phone.count > 15 { return "Phone must be at most 15 characters" }
        return ""
    }
    
    var passwordHint: String {
        if password.isEmpty { return "" }
        if password.count < 5 { return "Password must be 5-15 characters" }
        if password.count > 15 { return "Password must be 5-15 characters" }
        return ""
    }
    
    // MARK: - Actions
    func signIn() async {
        guard isSignInValid else { return }
        isLoading = true
        errorMessage = nil
        signInSuccess = false
        userNameFromAPI = nil
        
        defer { isLoading = false }
        
        let endpoint = APIEndpoint.login(
            email: email,
            password: password,
            fcmToken: "123"
        )
        
        do {
            let response: LoginResponse = try await APIService.shared.request(endpoint)
            print("[Login] API Response - success: \(response.success ?? false), message: \(response.message ?? "nil")")
            signInSuccess = response.success ?? false
            userNameFromAPI = response.data?.user?.name ?? response.user?.name ?? email.split(separator: "@").first.map { String($0).capitalized }
            if !signInSuccess {
                errorMessage = response.message ?? "Invalid credentials"
                print("[Login] Wrong credentials - \(errorMessage ?? "")")
            }
        } catch let error as APIError {
            errorMessage = error.localizedDescription
            print("[Login] API Error - \(error.localizedDescription)")
        } catch {
            errorMessage = error.localizedDescription
            print("[Login] Error - \(error.localizedDescription)")
        }
    }
    
    func signUp() async {
        guard isSignUpValid else { return }
        isLoading = true
        errorMessage = nil
        signUpSuccess = false
        defer { isLoading = false }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let dobString = formatter.string(from: dateOfBirth)
        
        let endpoint = APIEndpoint.createAccount(
            fullName: fullName,
            email: email,
            password: password,
            phone: phone,
            dob: dobString
        )
        
        do {
            let response: CreateAccountResponse = try await APIService.shared.request(endpoint)
            print("[SignUp] API Response - success: \(response.success ?? false), message: \(response.message ?? "nil")")
            signUpSuccess = response.success ?? false
            if !signUpSuccess {
                errorMessage = response.message ?? "Sign up failed"
                print("[SignUp] Failed - \(errorMessage ?? "")")
            }
        } catch let error as APIError {
            errorMessage = error.localizedDescription
            print("[SignUp] API Error - \(error.localizedDescription)")
        } catch {
            errorMessage = error.localizedDescription
            print("[SignUp] Error - \(error.localizedDescription)")
        }
    }
    
    func resetForm() {
        email = ""
        password = ""
        fullName = ""
        phone = ""
        dateOfBirth = .now
        hasSelectedDOB = false
        agreedToTerms = false
        errorMessage = nil
    }
}
