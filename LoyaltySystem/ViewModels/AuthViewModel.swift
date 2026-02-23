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
    
    // MARK: - Sign Up
    @Published var fullName: String = ""
    @Published var phone: String = ""
    @Published var dateOfBirth: Date = .now
    @Published var hasSelectedDOB: Bool = false
    @Published var agreedToTerms: Bool = false
    
    // MARK: - Validation
    var isSignInValid: Bool {
        !email.isEmpty && !password.isEmpty
    }
    
    var isSignUpValid: Bool {
        !fullName.isEmpty &&
        !email.isEmpty &&
        !phone.isEmpty &&
        hasSelectedDOB &&
        password.count >= 8 &&
        agreedToTerms
    }
    
    var passwordHint: String {
        password.count >= 8 ? "" : "Password must be 8 character"
    }
    
    // MARK: - Actions
    func signIn() async {
        guard isSignInValid else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        // TODO: Implement API call
    }
    
    func signUp() async {
        guard isSignUpValid else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        // TODO: Implement API call
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
