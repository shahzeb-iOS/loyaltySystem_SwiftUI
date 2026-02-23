//
//  Font+App.swift
//  LoyaltySystem
//
//  Derma&Shape app typography using system fonts.
//  To use custom fonts: add .ttf/.otf files to Fonts/ folder,
//  register in Info.plist under UIAppFonts, then update these names.
//

import SwiftUI

extension Font {
    
    // MARK: - Headings
    /// Large bold titles (e.g., "Book Appointments", "Sign in now")
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
