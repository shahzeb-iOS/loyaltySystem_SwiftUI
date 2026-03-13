# Firebase FCM Setup

FCM token is now fetched from Firebase and sent with the login request. Complete these steps:

## 1. Firebase iOS SDK (already added)
The project references the **firebase-ios-sdk** Swift package (FirebaseCore, FirebaseMessaging). Open the project in Xcode and let it resolve packages if prompted.

## 2. GoogleService-Info.plist
1. Go to [Firebase Console](https://console.firebase.google.com/) → your project.
2. Add an iOS app (or select existing) with bundle ID: `com.LoyaltySystem.LoyaltySystem`.
3. Download **GoogleService-Info.plist** and add it to the **LoyaltySystem** target (drag into the project, ensure "Copy items" and target membership are checked).

## 3. Push Notifications capability
1. In Xcode: select the **LoyaltySystem** target → **Signing & Capabilities**.
2. Click **+ Capability** and add **Push Notifications**.

## 4. APNs (Apple Push Notification service)
For a real device FCM token, you need to configure APNs:
- In Firebase Console: **Project Settings** → **Cloud Messaging** → upload your **APNs Authentication Key** (or certificate).
- Without this, FCM token may be `nil` on device; on simulator it often stays `nil`.

After this, login will send the live FCM token; if token is unavailable, an empty string is sent.
