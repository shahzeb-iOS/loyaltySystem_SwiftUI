//
//  BookAppointmentView.swift
//  LoyaltySystem
//
//  Book Appointment - Select Branch screen
//

import SwiftUI

struct BookAppointmentView: View {
    let onBack: () -> Void
    let onContinue: () -> Void
    
    @State private var selectedBranch: String? = "San Jerónimo"
    
    var body: some View {
        VStack(spacing: 0) {
            header
            progressIndicator
            selectBranchSection
            Spacer()
            continueButton
        }
        .background(Color.appBackgroundWhite)
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
            
            Text("Book Appointment")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 12)
    }
    
    private var progressIndicator: some View {
        HStack(spacing: 2) {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.appAccentGold)
                .frame(maxWidth: .infinity)
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.appTextSecondary.opacity(0.25))
                .frame(maxWidth: .infinity)
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.appTextSecondary.opacity(0.25))
                .frame(maxWidth: .infinity)
        }
        .frame(height: 4)
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
    
    private var selectBranchSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Select Branch")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)
            
            VStack(spacing: 10) {
                branchOption("San Jerónimo", isSelected: selectedBranch == "San Jerónimo") {
                    selectedBranch = "San Jerónimo"
                }
                branchOption("Carretera Nacional", isSelected: selectedBranch == "Carretera Nacional") {
                    selectedBranch = "Carretera Nacional"
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    private func branchOption(_ name: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: "mappin")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(isSelected ? .appAccentGold : .appTextSecondary)
                
                Text(name)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.black)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.appAccentGold)
                }
            }
            .padding(14)
            .background(isSelected ? Color.appAccentGold.opacity(0.2) : Color.appBackgroundWhite)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.clear : Color.appTextSecondary.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
    
    private var continueButton: some View {
        Button(action: onContinue) {
            Text("Continue")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.appPrimaryDark)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
}

struct BookAppointmentView_Previews: PreviewProvider {
    static var previews: some View {
        BookAppointmentView(onBack: {}, onContinue: {})
    }
}
