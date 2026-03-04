//
//  Font+App.swift
//  LoyaltySystem
//
//  Derma&Shape app typography using Poppins and system fonts.
//

import SwiftUI

extension Font {

    // MARK: - Poppins (Onboarding)
    /// Onboarding title - Poppins Semibold 30
    static let appOnboardingTitle = Font.custom("Poppins-SemiBold", size: 30)

    /// Onboarding subtitle/description - Poppins Regular 16
    static let appOnboardingSubtitle = Font.custom("Poppins-Regular", size: 16)

    /// Onboarding button title - Poppins Semibold 16
    static let appOnboardingButton = Font.custom("Poppins-SemiBold", size: 16)

    // MARK: - Alert
    /// Alert title - Poppins Semibold 18
    static let appAlertTitle = Font.custom("Poppins-SemiBold", size: 18)

    /// Alert subtitle - Poppins Regular 16
    static let appAlertSubtitle = Font.custom("Poppins-Regular", size: 16)

    // MARK: - OTP Verification
    /// OTP title - Poppins Semibold 26
    static let appOTPTitle = Font.custom("Poppins-SemiBold", size: 26)

    /// OTP subtitle - Poppins Regular 14
    static let appOTPSubtitle = Font.custom("Poppins-Regular", size: 14)

    /// OTP code label - Poppins Semibold 20
    static let appOTPCodeLabel = Font.custom("Poppins-SemiBold", size: 20)

    /// OTP resend - Poppins Regular 14
    static let appOTPResend = Font.custom("Poppins-Regular", size: 14)

    // MARK: - Auth (Sign In, Sign Up, Forgot Password)
    /// Auth screen title - 26 semibold
    static let appAuthTitle = Font.system(size: 26, weight: .semibold)

    /// Auth screen subtitle - 16 regular
    static let appAuthSubtitle = Font.system(size: 16, weight: .regular)

    // MARK: - Headings
    /// Large bold titles (e.g., "Book Appointments")
    static let appTitle = Font.system(size: 28, weight: .bold)

    /// Section subtitles and instructions
    static let appSubtitle = Font.system(size: 16, weight: .regular)
    
    /// Small accent text (e.g., "Skip", "Forgot Password?")
    static let appCaption = Font.system(size: 14, weight: .regular)
    
    // MARK: - Body
    /// Body text and descriptions
    static let appBody = Font.system(size: 16, weight: .regular)
    
    /// Input placeholder and secondary text
    static let appPlaceholder = Font.system(size: 16, weight: .regular)
    
    /// Small hint text (e.g., "Password must be 8 character")
    static let appHint = Font.system(size: 12, weight: .regular)
    
    // MARK: - Brand
    /// "DERMA&SHAPE" logo text - clean bold sans-serif
    static let appBrand = Font.system(size: 18, weight: .bold)
    
    /// "Truly Elegant" script/tagline - uses system cursive font
    static let appTagline = Font.system(size: 14, weight: .regular).italic()
    
    // MARK: - Buttons
    static let appButton = Font.system(size: 17, weight: .semibold)
}
