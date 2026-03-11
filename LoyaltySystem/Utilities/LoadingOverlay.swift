//
//  LoadingOverlay.swift
//  LoyaltySystem
//
//  Full-screen loading overlay + top-center spinner
//

import SwiftUI

/// Spinner at top center of view with visible color (nazar aaye)
struct SpinnerView: View {
    var tint: Color = Color.appAccentGold
    
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: tint))
            .scaleEffect(1.4)
    }
}

/// Full-width overlay with spinner at top center (for list/detail screens)
struct SpinnerOverlayView: View {
    var tint: Color = Color.appAccentGold
    
    var body: some View {
        VStack(spacing: 0) {
            SpinnerView(tint: tint)
                .padding(.top, 48)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct LoadingOverlay: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                
                Text("Loading...")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
            }
        }
    }
}

struct LoadingOverlay_Previews: PreviewProvider {
    static var previews: some View {
        LoadingOverlay()
    }
}
