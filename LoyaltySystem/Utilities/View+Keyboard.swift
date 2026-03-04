//
//  View+Keyboard.swift
//  LoyaltySystem
//
//  Dismiss keyboard when tapping anywhere
//

import SwiftUI

extension View {
    /// Dismisses the keyboard when tapping anywhere on the view
    func hideKeyboardOnTap() -> some View {
        self.simultaneousGesture(
            TapGesture().onEnded { _ in
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        )
    }
}
