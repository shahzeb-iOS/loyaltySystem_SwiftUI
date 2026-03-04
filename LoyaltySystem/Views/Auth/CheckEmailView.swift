//
//  CheckEmailView.swift
//  LoyaltySystem
//
//  Check your email - confirmation modal/card after forgot password
//

import SwiftUI

struct CheckEmailView: View {
    let email: String
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { onDismiss() }
            
            VStack(spacing: 20) {
                Image("checkEmailIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                
                Text("Check your email")
                    .font(.appAlertTitle)
                    .foregroundColor(.appTextPrimary)
                
                Text("We have send password recovery instruction to your email")
                    .font(.appAlertSubtitle)
                    .foregroundColor(.appTextSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(24)
            .frame(maxWidth: 320)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 40)
        }
    }
}

#Preview {
    CheckEmailView(email: "abc@gmail.com", onDismiss: {})
}
