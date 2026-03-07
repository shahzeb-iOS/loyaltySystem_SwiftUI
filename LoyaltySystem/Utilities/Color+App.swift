//
//  Color+App.swift
//  LoyaltySystem
//
//  App color palette - matches Assets.xcassets/Colors
//

import SwiftUI

extension Color {
    
    /// Dark navy - primary buttons, splash background (#1A2033)
    static let appPrimaryDark = Color("PrimaryDark")
    
    /// Gold/brown accent - highlights, links, icons (#C0A06D)
    static let appAccentGold = Color("AccentGold")
    
    /// Light background (#F8F8F8)
    static let appBackground = Color("BackgroundLight")
    
    /// White background (#FFFFFF)
    static let appBackgroundWhite = Color("BackgroundWhite")
    
    /// Primary text color (#333333)
    static let appTextPrimary = Color("TextPrimary")
    
    /// Secondary/muted text (#666666)
    static let appTextSecondary = Color("TextSecondary")
    
    /// Input field background (#F0F0F0) / light beige
    static let appInputBackground = Color("InputBackground")
    
    /// Light beige - back button circle, input fields (#F5F0E6)
    static let appLightBeige = Color("LightBeige")
    
    /// Focus blue - active input border (#007AFF)
    static let appFocusBlue = Color("FocusBlue")
    
    /// Focus border - soft gold for selected fields (matches app theme)
    static let appFocusBorder = Color(red: 160/255, green: 130/255, blue: 80/255)
    
    /// Error/validation hint - soft coral (softer than red)
    static let appErrorText = Color(red: 200/255, green: 95/255, blue: 85/255)
    
    /// Gold Member tag background (#29354b)
    static let appGoldMemberBg = Color(red: 41/255, green: 53/255, blue: 75/255)
    
    /// Gold Member text color (#b8904d)
    static let appGoldMemberText = Color(red: 184/255, green: 144/255, blue: 77/255)
}
