//
//  ProfileView.swift
//  LoyaltySystem
//
//  Profile screen - user info and settings
//

import SwiftUI

struct ProfileView: View {
    let loggedInUser: LoggedInUser
    let onBack: () -> Void
    let onSignOut: () -> Void
    
    @State private var showLogoutAlert = false
    
    private var userEmail: String { loggedInUser.email.isEmpty ? "—" : loggedInUser.email }
    private var membership: String { "Gold Tier" }
    private var loyaltyId: String { "#\(loggedInUser.id)" }
    
    private let lightPink = Color(red: 255/255, green: 230/255, blue: 230/255)
    private let signOutRed = Color(red: 220/255, green: 100/255, blue: 80/255)
    
    var body: some View {
        VStack(spacing: 0) {
            header
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24) {
                    profileHeader
                    infoFields
                    actionButtons
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 100)
            }
        }
        .background(Color.appBackgroundWhite)
        .alert("Sign out?", isPresented: $showLogoutAlert) {
            Button("No", role: .cancel) { }
            Button("Logout", role: .destructive) {
                onSignOut()
            }
        } message: {
            Text("Are you sure you want to sign out?")
        }
    }
    
    private var header: some View {
        HStack(spacing: 16) {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.appTextSecondary)
                    .frame(width: 44, height: 44)
                    .background(Color.appLightBeige)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            
            Text("Profile")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.black)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 12)
    }
    
    private var profileHeader: some View {
        VStack(spacing: 12) {
            // Avatar with edit button overlay
            ZStack(alignment: .bottomTrailing) {
                ZStack {
                    lightPink
                    Image(systemName: "person.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.appTextSecondary.opacity(0.5))
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                
                Button(action: {}) {
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(Color.appAccentGold)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
                .offset(x: 4, y: 4)
            }
            
            Text(loggedInUser.name.isEmpty ? "Guest" : loggedInUser.name)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.black)
            
            Text(userEmail)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.appTextSecondary)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var infoFields: some View {
        VStack(spacing: 12) {
            profileField(icon: "person", label: "Name", value: loggedInUser.name.isEmpty ? "—" : loggedInUser.name)
            profileField(icon: "creditcard", label: "Membership", value: membership)
            profileField(icon: "phone", label: "Phone", value: loggedInUser.phone ?? "—")
            profileField(icon: "exclamationmark.circle", label: "Loyalty ID", value: loyaltyId)
        }
    }
    
    private func profileField(icon: String, label: String, value: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(.appAccentGold)
                .frame(width: 24, alignment: .center)
            
            Text(label)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.appTextSecondary)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.black)
        }
        .padding(16)
        .background(Color.appBackgroundWhite)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.appTextSecondary.opacity(0.15), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button(action: { showLogoutAlert = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 18, weight: .medium))
                    Text("Sign out")
                        .font(.system(size: 16, weight: .medium))
                }
                .foregroundColor(signOutRed)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(lightPink)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
            
            Button(action: {}) {
                HStack(spacing: 8) {
                    Image(systemName: "trash")
                        .font(.system(size: 18, weight: .medium))
                    Text("Delete Profile")
                        .font(.system(size: 16, weight: .medium))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.red)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(loggedInUser: LoggedInUser(id: "1", name: "Yuly", email: "yuly@example.com"), onBack: {}, onSignOut: {})
    }
}
