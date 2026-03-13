//
//  AppDelegate+Firebase.swift
//  LoyaltySystem
//
//  Configures Firebase only if GoogleService-Info.plist exists; registers for remote notifications.
//

import UIKit
import FirebaseCore
import FirebaseMessaging
import UserNotifications

final class AppDelegate: NSObject, UIApplicationDelegate {
    /// Set to true only when GoogleService-Info.plist is present and configure() was called.
    static var isFirebaseConfigured = false
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        if Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") != nil {
            FirebaseApp.configure()
            AppDelegate.isFirebaseConfigured = true
            requestNotificationPermissionAndRegister(application: application)
        } else {
            print("[Firebase] GoogleService-Info.plist not found – add it from Firebase Console. FCM token will be empty.")
        }
        return true
    }
    
    private func requestNotificationPermissionAndRegister(application: UIApplication) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
        application.registerForRemoteNotifications()
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        guard AppDelegate.isFirebaseConfigured else { return }
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("[FCM] APNs registration failed: \(error.localizedDescription)")
    }
}
