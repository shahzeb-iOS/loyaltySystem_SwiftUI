//
//  SplashView.swift
//  LoyaltySystem
//
//  Splash screen with DS logo and brand
//

import SwiftUI

struct SplashView: View {
    let onComplete: () -> Void
    
    var body: some View {
        ZStack {
            Color.appPrimaryDark
                .ignoresSafeArea()
            
            VStack(spacing: 8) {
                // DS Logo - use asset when available, placeholder for now
                Image(systemName: "sparkles")
                    .font(.system(size: 60))
                    .foregroundColor(.white)
                
                Text("DERMA&SHAPE")
                    .font(.appBrand)
                    .foregroundColor(.white)
                    .tracking(2)
                
                Text("Truly Elegant")
                    .font(.appTagline)
                    .foregroundColor(.white.opacity(0.9))
            }
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
