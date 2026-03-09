//
//  SetNewPasswordView.swift
//  LoyaltySystem
//
//  Set new password - single password field with eye icon
//

import SwiftUI

struct SetNewPasswordView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var isUpdating = false
    @State private var updateError: String?
    let email: String
    let onBack: () -> Void
    let onResetComplete: () -> Void
    
    var body: some View {
        ZStack {
            Color.appBackgroundWhite
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    HStack {
                        Button { onBack() } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.appAccentGold)
                                .frame(width: 44, height: 44)
                                .background(Color.appLightBeige)
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 8)
                    
                    Spacer().frame(height: 20)
                    
                    Text("Set New Password")
                        .font(.appAuthTitle)
                        .foregroundColor(.appTextPrimary)
                    
                    Text("Enter Your New Password")
                        .font(.appAuthSubtitle)
                        .foregroundColor(.appTextSecondary)
                    
                    // Password field with eye icon
                    HStack(spacing: 12) {
                        Group {
                            if viewModel.isPasswordVisible {
                                TextField("Enter your password", text: Binding(
                                    get: { viewModel.password },
                                    set: { viewModel.password = String($0.prefix(15)) }
                                ))
                            } else {
                                SecureField("Enter your password", text: Binding(
                                    get: { viewModel.password },
                                    set: { viewModel.password = String($0.prefix(15)) }
                                ))
                            }
                        }
                        .textFieldStyle(.plain)
                        
                        Button {
                            viewModel.isPasswordVisible.toggle()
                        } label: {
                            Image(systemName: viewModel.isPasswordVisible ? "eye.slash" : "eye")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.appAccentGold)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    .background(Color.appLightBeige)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal, 24)
                    
                    if !viewModel.passwordHint.isEmpty {
                        Text(viewModel.passwordHint)
                            .font(.appHint)
                            .foregroundColor(.appErrorText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 24)
                    }
                    
                    if let err = updateError {
                        Text(err)
                            .font(.appHint)
                            .foregroundColor(.appErrorText)
                            .padding(.horizontal, 24)
                    }
                    
                    Button("Reset Password") {
                        updateError = nil
                        guard viewModel.password.count >= 4, viewModel.password.count <= 15, !email.isEmpty else { return }
                        Task { await updatePassword() }
                    }
                    .font(.appButton)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.appPrimaryDark)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .disabled(viewModel.password.count < 4 || viewModel.password.count > 15 || email.isEmpty || isUpdating)
                    .opacity(viewModel.password.count >= 4 && viewModel.password.count <= 15 && !email.isEmpty && !isUpdating ? 1 : 0.6)
                    .padding(.horizontal, 24)
                }
                .padding(.vertical, 24)
            }
        }
    }
    
    private func updatePassword() async {
        isUpdating = true
        defer { isUpdating = false }
        let endpoint = APIEndpoint.updatePassword(email: email, newpassword: viewModel.password)
        do {
            let response: MessageResponse = try await APIService.shared.request(endpoint)
            let ok = response.success ?? response.status ?? false
            let msg = (response.message ?? "").lowercased()
            if ok || msg.contains("success") {
                await MainActor.run { onResetComplete() }
            } else {
                await MainActor.run { updateError = response.message ?? "Failed to update password" }
            }
        } catch {
            await MainActor.run { updateError = error.localizedDescription }
        }
    }
}

struct SetNewPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        SetNewPasswordView(email: "user@example.com", onBack: {}, onResetComplete: {})
    }
}
