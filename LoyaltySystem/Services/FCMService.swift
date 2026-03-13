//
//  FCMService.swift
//  LoyaltySystem
//
//  Fetches FCM token from Firebase for login/API. Add Firebase via SPM:
//  File → Add Package Dependencies → https://github.com/firebase/firebase-ios-sdk
//  Add: FirebaseCore, FirebaseMessaging
//

import Foundation
import FirebaseCore
import FirebaseMessaging

final class FCMService {
    static let shared = FCMService()
    
    private init() {}
    
    /// Fetches current FCM token. Returns nil if GoogleService-Info.plist is missing, or token unavailable.
    func getToken() async -> String? {
        guard AppDelegate.isFirebaseConfigured else { return nil }
        do {
            let token = try await Messaging.messaging().token()
            return token.isEmpty ? nil : token
        } catch {
            print("[FCM] Failed to get token: \(error.localizedDescription)")
            return nil
        }
    }
}
