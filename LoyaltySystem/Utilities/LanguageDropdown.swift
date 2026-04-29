//
//  LanguageDropdown.swift
//  LoyaltySystem
//
//  Custom dropdown to switch app language (EN / ES)
//

import SwiftUI

struct LanguageDropdown: View {
    @EnvironmentObject private var languageManager: LanguageManager
    @State private var isOpen = false
    @State private var anchorWidth: CGFloat = 0
    @State private var anchorHeight: CGFloat = 0
    
    private var currentTitle: String {
        languageManager.currentLanguageCode == "es" ? "Español" : "English"
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            if isOpen {
                Color.clear
                    .contentShape(Rectangle())
                    .ignoresSafeArea()
                    .onTapGesture {
                        isOpen = false
                    }
            }
            
            Button {
                isOpen.toggle()
            } label: {
                HStack(spacing: 8) {
                    Text(currentTitle)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.appPrimaryDark)
                        .lineLimit(1)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.appPrimaryDark.opacity(0.75))
                        .rotationEffect(.degrees(isOpen ? 180 : 0))
                        .animation(.easeInOut(duration: 0.18), value: isOpen)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 14)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.appTextSecondary.opacity(0.12), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.10), radius: 10, x: 0, y: 4)
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                anchorWidth = geo.size.width
                                anchorHeight = geo.size.height
                            }
                            .onChange(of: geo.size.width) { newValue in anchorWidth = newValue }
                            .onChange(of: geo.size.height) { newValue in anchorHeight = newValue }
                    }
                )
            }
            .buttonStyle(.plain)
            
            if isOpen {
                VStack(alignment: .leading, spacing: 0) {
                    optionRow(title: "English", code: "en")
                    Divider().opacity(0.16)
                    optionRow(title: "Español", code: "es")
                }
                .padding(.vertical, 6)
                .frame(width: max(140, anchorWidth + 20), alignment: .leading)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.appTextSecondary.opacity(0.12), lineWidth: 1)
                )
                .overlay(
                    Rectangle()
                        .fill(Color.appTextSecondary.opacity(0.12))
                        .frame(height: 1),
                    alignment: .top
                )
                .shadow(color: .black.opacity(0.12), radius: 14, x: 0, y: 6)
                // dropdown ko top 0 / button ke bilkul neeche
                .offset(y: anchorHeight + 2)
            }
        }
        .fixedSize(horizontal: true, vertical: false)
        .zIndex(2000)
    }
    
    private func optionRow(title: String, code: String) -> some View {
        let isSelected = languageManager.currentLanguageCode == code
        return Button {
            // Language change should not animate the whole screen (prevents blink)
            var t = Transaction()
            t.disablesAnimations = true
            withTransaction(t) {
                languageManager.setLanguage(code)
                isOpen = false
            }
        } label: {
            HStack(spacing: 10) {
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.appPrimaryDark)
                Spacer(minLength: 0)
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.appAccentGold)
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
        }
        .buttonStyle(.plain)
    }
}

