//
//  LoyaltySystemApp.swift
//  LoyaltySystem
//
//  Created by Shahzaib on 23/02/2026.
//

import SwiftUI

@main
struct LoyaltySystemApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .preferredColorScheme(.light)
        }
    }
}
