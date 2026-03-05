//
//  HomeView.swift
//  LoyaltySystem
//
//  Dashboard / Home screen with points, appointments, promotions
//

import SwiftUI

struct HomeView: View {
    let userName: String
    @State private var showBookAppointment = false
    @State private var showCatalog = false
    @State private var showNotifications = false
    
    var body: some View {
        VStack(spacing: 0) {
            navigationBar
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    // Header
                    headerSection
                        .padding(.bottom, 24)
                
                // Points Balance Card
                pointsBalanceCard
                    .padding(.bottom, 24)
                
                // Quick Actions
                quickActionsSection
                    .padding(.bottom, 24)
                
                // Next Appointment
                nextAppointmentSection
                    .padding(.bottom, 24)
                
                // Promotions
                promotionsSection
                    .padding(.bottom, 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
        }
        .background(Color.appBackgroundWhite)
        .fullScreenCover(isPresented: $showBookAppointment) {
            BookAppointmentFlowView(onDismiss: { showBookAppointment = false })
        }
        .fullScreenCover(isPresented: $showCatalog) {
            CatalogView(onBack: { showCatalog = false })
        }
        .fullScreenCover(isPresented: $showNotifications) {
            NotificationsView(onDismiss: { showNotifications = false })
        }
    }
    
    private var navigationBar: some View {
        HStack {
            Spacer()
            Button { showNotifications = true } label: {
                Image("notificationIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .frame(width: 44, height: 44)
                    .background(Color.appLightBeige)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 8)
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text("Hello, \(userName)!")
                .font(.appGreeting)
                .foregroundColor(.black)
            
            Text("How can we help you today?")
                .font(.appGreetingSubtitle)
                .foregroundColor(.appTextSecondary)
        }
    }
    
    private var pointsBalanceCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Points Balance")
                    .font(.custom("Poppins-Regular", size: 16))
                    .foregroundColor(.appTextSecondary)
                
                Spacer()
                
                Text("Gold Member")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.appGoldMemberText)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.appGoldMemberBg)
                    .clipShape(RoundedRectangle(cornerRadius: 43))
                    .overlay(
                        RoundedRectangle(cornerRadius: 43)
                            .stroke(Color.white.opacity(0.47), lineWidth: 1)
                    )
            }
            
            Spacer().frame(height: 3)
            
            Text("1250")
                .font(.appPointsValue)
                .foregroundColor(.appAccentGold)
                .padding(.bottom, 5)
            
            HStack(alignment: .bottom, spacing: 12) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Tier Progress")
                        .font(.appPointsLabel)
                        .foregroundColor(.appTextSecondary)
                    
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white)
                            .frame(height: 6)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.appAccentGold)
                            .frame(width: 120, height: 6)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 6)
                    
                    Text("750 points until Platinum")
                        .font(.appGreetingSubtitle)
                        .foregroundColor(.appTextSecondary)
                }
                
                Button("REDEEM") {
                    // TODO
                }
                .font(.system(size: 9, weight: .semibold))
                .foregroundColor(.white)
                .frame(height: 26)
                .padding(.horizontal, 16)
                .background(Color.appAccentGold)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
        .padding(.top, 15)
        .background(Color.appPrimaryDark)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var quickActionsSection: some View {
        HStack(spacing: 20) {
            quickActionCard(
                icon: "calendar",
                title: "New Appointment",
                action: { showBookAppointment = true }
            )
            .frame(maxWidth: .infinity)
            
            quickActionCard(
                icon: "square.grid.2x2",
                title: "Catalog",
                action: { showCatalog = true }
            )
            .frame(maxWidth: .infinity)
        }
    }
    
    private func quickActionCard(icon: String, title: String, action: @escaping () -> Void = {}) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(.appAccentGold)
                    .frame(width: 20, height: 20)
                
                Text(title)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.appTextPrimary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.appBackgroundWhite)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.appAccentGold.opacity(0.5), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
    
    private var nextAppointmentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "NEXT APPOINTMENT", seeAllAction: {})
            
            nextAppointmentCard
        }
    }
    
    private var nextAppointmentCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Classic Facial")
                    .font(.appSectionHeader)
                    .foregroundColor(.black)
                
                Spacer()
                
                Text("Confirmed")
                    .font(.appCaption)
                    .foregroundColor(.appTextPrimary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.appAccentGold)
                    .clipShape(Capsule())
            }
            
            HStack(spacing: 4) {
                Image(systemName: "mappin")
                    .font(.system(size: 12))
                    .foregroundColor(.appTextSecondary)
                Text("Lahore Spa")
                    .font(.appBody)
                    .foregroundColor(.appTextSecondary)
            }
            
            HStack(spacing: 16) {
                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .font(.system(size: 14))
                        .foregroundColor(.appTextPrimary)
                    Text("Feb 14, 2026")
                        .font(.appBody)
                        .foregroundColor(.black)
                }
                
                HStack(spacing: 6) {
                    Image(systemName: "clock")
                        .font(.system(size: 14))
                        .foregroundColor(.appTextPrimary)
                    Text("10:00 AM")
                        .font(.appBody)
                        .foregroundColor(.black)
                }
            }
        }
        .padding(16)
        .background(Color.appBackgroundWhite)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.appLightBeige, lineWidth: 1)
        )
    }
    
    private var promotionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "Promotions", seeAllAction: {})
            
            promotionCard
        }
    }
    
    private var promotionCard: some View {
        HStack(spacing: 0) {
            ZStack {
                Color.appAccentGold
                
                VStack(spacing: 0) {
                    Text("20%")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.appPrimaryDark)
                    Text("OFF")
                        .font(.appCaption)
                        .foregroundColor(.appPrimaryDark)
                }
            }
            .frame(width: 100, height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 8) {
                Text("All Facial Treatments")
                    .font(.appSectionHeader)
                    .foregroundColor(.white)
                
                Text("Get 20% off on all facial treatments. Limited time only!")
                    .font(.appGreetingSubtitle)
                    .foregroundColor(.white.opacity(0.9))
                
                Spacer()
                
                HStack {
                    Spacer()
                    Button("BOOK NOW") {
                        // TODO
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.appTextPrimary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.appAccentGold)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 120)
        .background(Color.appPrimaryDark)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func sectionHeader(title: String, seeAllAction: @escaping () -> Void) -> some View {
        HStack {
            Text(title)
                .font(.appSectionHeader)
                .foregroundColor(.black)
            
            Spacer()
            
            Button(action: seeAllAction) {
                Text("See All")
                    .font(.custom("Poppins-SemiBold", size: 10))
                    .foregroundColor(.appAccentGold)
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    HomeView(userName: "Yuly")
}
