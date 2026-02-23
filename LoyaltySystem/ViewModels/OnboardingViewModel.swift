//
//  OnboardingViewModel.swift
//  LoyaltySystem
//
//  ViewModel for onboarding flow
//

import Foundation
import SwiftUI

@MainActor
final class OnboardingViewModel: ObservableObject {
    
    @Published var currentPage: Int = 0
    @Published var hasCompletedOnboarding: Bool = false
    
    let items = OnboardingItem.items
    let totalPages: Int = OnboardingItem.items.count
    
    var isLastPage: Bool {
        currentPage == totalPages - 1
    }
    
    var buttonTitle: String {
        currentPage == 0 ? "Get Started" : "Next"
    }
    
    func nextPage() {
        if isLastPage {
            hasCompletedOnboarding = true
        } else {
            currentPage += 1
        }
    }
    
    func skip() {
        hasCompletedOnboarding = true
    }
}
