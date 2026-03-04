//
//  SplashView.swift
//  LoyaltySystem
//
//  Splash screen with StartIcon
//

import SwiftUI

struct SplashView: View {
    let onComplete: () -> Void
    
    var body: some View {
        ZStack {
            Color.appPrimaryDark
                .ignoresSafeArea()
            
            Image("StartIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                onComplete()
            }
        }
    }
}

#Preview {
    SplashView(onComplete: {})
}
