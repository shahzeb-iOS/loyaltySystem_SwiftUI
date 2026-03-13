//
//  LoadingOverlay.swift
//  LoyaltySystem
//
//  Full-screen loading overlay – pura view cover, center mein spinner + card
//

import SwiftUI

/// Full-view overlay – pura screen cover (dim + center card + spinner). Jab bhi loader chale, poori view pe ho.
struct LoadingOverlay: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.all)
            
            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.appAccentGold))
                    .scaleEffect(2)
                Text("Loading...")
                    .font(.custom("Poppins-Regular", size: 15))
                    .foregroundColor(.appTextSecondary)
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 28)
            .background(Color.appBackgroundWhite)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.12), radius: 20, x: 0, y: 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.all)
    }
}

/// Purane use ke liye – same as LoadingOverlay (full screen)
struct SpinnerView: View {
    var tint: Color = Color.appAccentGold
    
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: tint))
            .scaleEffect(1.4)
    }
}

struct SpinnerOverlayView: View {
    var tint: Color = Color.appAccentGold
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea(.all)
            SpinnerView(tint: tint)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.all)
    }
}

struct LoadingOverlay_Previews: PreviewProvider {
    static var previews: some View {
        LoadingOverlay()
    }
}
