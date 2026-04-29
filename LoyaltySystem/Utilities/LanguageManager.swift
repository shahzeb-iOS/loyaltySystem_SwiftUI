//
//  LanguageManager.swift
//  LoyaltySystem
//
//  Simple runtime language switcher (forces RootView refresh)
//

import Foundation
import SwiftUI

@MainActor
final class LanguageManager: ObservableObject {
    private let selectedLanguageKey = "selectedLanguageCode"
    @Published private(set) var currentLanguageCode: String
    @Published private(set) var locale: Locale

    init() {
        // Stable source of truth (works without app restart)
        let saved = UserDefaults.standard.string(forKey: selectedLanguageKey)?.lowercased()
        let preferred = (UserDefaults.standard.array(forKey: "AppleLanguages") as? [String])?.first
        let preferredRaw = preferred.flatMap { String($0.prefix(2)).lowercased() }
        
        let initial = (saved ?? preferredRaw) == "es" ? "es" : "en"
        currentLanguageCode = initial
        locale = Locale(identifier: initial)
        
        // Ensure a stable default for first install
        if saved == nil && preferred == nil {
            UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
            UserDefaults.standard.set("en", forKey: "AppleLocale")
            UserDefaults.standard.set("en", forKey: selectedLanguageKey)
        }
    }

    func setLanguage(_ code: String) {
        let normalized = code.lowercased().hasPrefix("es") ? "es" : "en"
        guard normalized != currentLanguageCode else { return }
        UserDefaults.standard.set(normalized, forKey: selectedLanguageKey)
        UserDefaults.standard.set([normalized], forKey: "AppleLanguages")
        UserDefaults.standard.set(normalized, forKey: "AppleLocale")
        currentLanguageCode = normalized
        locale = Locale(identifier: normalized)
    }
}

