//
//  OTPVerificationView.swift
//  LoyaltySystem
//
//  OTP Verification - 4 digit fields, Verify button, Resend timer
//

import SwiftUI

struct OTPVerificationView: View {
    @StateObject private var viewModel = OTPViewModel()
    @FocusState private var focusedField: Int?
    @State private var isVerifying = false
    @State private var isResending = false
    @State private var verifyError: String?
    @State private var resendError: String?
    let email: String
    let onBack: () -> Void
    let onVerified: () -> Void
    
    var body: some View {
        ZStack {
            Color.appBackgroundWhite
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
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
                    .padding(.bottom, 12)
                    
                    Image(systemName: "key.fill")
                        .font(.system(size: 64))
                        .foregroundColor(.appAccentGold)
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                    
                    Text("OTP Verification")
                        .font(.appOTPTitle)
                        .foregroundColor(.appTextPrimary)
                        .frame(maxWidth: .infinity)
                    
                    Text("Please check your email \(email) to see the verification code")
                        .font(.appOTPSubtitle)
                        .foregroundColor(.appTextSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 17)
                        .padding(.top, 10)
                    .padding(.bottom, 24)
                    
                    // 4 OTP digit fields: first empty → next sab disable; pichle mein value ho to next enable
                    HStack(spacing: 16) {
                        ForEach(0..<4, id: \.self) { index in
                            let isEnabled = index == 0 || viewModel.digit(at: index - 1).count == 1
                            OTPDigitField(
                                digit: binding(for: index),
                                isFocused: viewModel.focusedIndex == index,
                                isEnabled: isEnabled,
                                onTap: {
                                    if index == 0 || viewModel.digit(at: index - 1).count == 1 {
                                        viewModel.focusedIndex = index
                                        focusedField = index
                                    }
                                }
                            )
                            .focused($focusedField, equals: index)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                    
                    if let err = verifyError {
                        Text(err)
                            .font(.appHint)
                            .foregroundColor(.appErrorText)
                            .padding(.horizontal, 24)
                            .padding(.top, 8)
                    }
                    
                    Button("Verify") {
                        verifyError = nil
                        let otp = viewModel.otpString
                        guard viewModel.isComplete, !otp.isEmpty else { return }
                        Task { await verifyOTP(otp: otp) }
                    }
                    .font(.appButton)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.appPrimaryDark)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .disabled(!viewModel.isComplete || isVerifying)
                    .opacity(viewModel.isComplete && !isVerifying ? 1 : 0.6)
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    .padding(.bottom, 10)
                    
                    HStack {
                        Spacer()
                        if viewModel.secondsRemaining > 0 {
                            HStack(spacing: 5) {
                                Text("Resend code")
                                    .font(.appOTPResend)
                                    .foregroundColor(.appTextSecondary)
                                Text(viewModel.timerString)
                                    .font(.appOTPResend)
                                    .foregroundColor(.appTextPrimary)
                                    .monospacedDigit()
                            }
                        } else {
                            Button("Resend") {
                                resendError = nil
                                Task { await sendOTP() }
                            }
                            .font(.appOTPResend)
                            .foregroundColor(.appAccentGold)
                            .disabled(isResending)
                            .opacity(isResending ? 0.6 : 1)
                        }
                        Spacer()
                    }
                    .padding(.top, 16)
                    
                    if let err = resendError {
                        Text(err)
                            .font(.appHint)
                            .foregroundColor(.appErrorText)
                            .padding(.horizontal, 24)
                            .padding(.top, 6)
                    }
                }
                .padding(.vertical, 24)
            }
            
            if isVerifying {
                LoadingOverlay()
                    .ignoresSafeArea()
            }
            if isResending {
                LoadingOverlay()
                    .ignoresSafeArea()
            }
        }
        .navigationBarHidden(true)
        .hideKeyboardOnTap()
        .onAppear {
            viewModel.startTimer()
            viewModel.focusedIndex = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                focusedField = 0
            }
        }
        .onDisappear { viewModel.stopTimer() }
        .onChange(of: viewModel.focusedIndex) { focusedField = $0 }
        .onChange(of: viewModel.isComplete) { if $0 { focusedField = nil } }
    }
    
    private func binding(for index: Int) -> Binding<String> {
        Binding(
            get: { viewModel.digit(at: index) },
            set: { viewModel.setDigit($0, at: index) }
        )
    }
    
    private func verifyOTP(otp: String) async {
        isVerifying = true
        defer { isVerifying = false }
        let endpoint = APIEndpoint.verifyOtp(email: email, otp: otp)
        do {
            let response: MessageResponse = try await APIService.shared.request(endpoint)
            let ok = response.success ?? response.status ?? false
            let msg = (response.message ?? "").lowercased()
            if ok || msg.contains("success") {
                await MainActor.run { onVerified() }
            } else {
                await MainActor.run { verifyError = response.message ?? "Verification failed" }
            }
        } catch {
            await MainActor.run { verifyError = error.localizedDescription }
        }
    }
    
    private func sendOTP() async {
        isResending = true
        defer { isResending = false }
        let endpoint = APIEndpoint.sendOTP(email: email)
        do {
            let response: MessageResponse = try await APIService.shared.request(endpoint)
            let ok = response.success ?? response.status ?? false
            let msg = (response.message ?? "").lowercased()
            if ok || msg.contains("success") {
                await MainActor.run {
                    viewModel.restartTimer()
                }
            } else {
                await MainActor.run { resendError = response.message ?? "Failed to resend code" }
            }
        } catch {
            await MainActor.run { resendError = error.localizedDescription }
        }
    }
}

struct OTPDigitField: View {
    @Binding var digit: String
    let isFocused: Bool
    let isEnabled: Bool
    let onTap: () -> Void
    
    var body: some View {
        TextField("", text: $digit)
            .keyboardType(.numberPad)
            .multilineTextAlignment(.center)
            .font(.custom("Poppins-SemiBold", size: 20))
            .frame(width: 56, height: 56)
            .background(Color.appLightBeige)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isFocused ? Color.appFocusBorder : Color.clear, lineWidth: 2)
            )
            .disabled(!isEnabled)
            .contentShape(Rectangle())
            .onTapGesture { onTap() }
    }
}

@MainActor
final class OTPViewModel: ObservableObject {
    @Published private(set) var digits: [String] = ["", "", "", ""]
    @Published var focusedIndex: Int = 0
    @Published private(set) var secondsRemaining: Int = 90
    private var timer: Timer?
    
    var timerString: String {
        let min = secondsRemaining / 60
        let sec = secondsRemaining % 60
        return String(format: "%02d:%02d", min, sec)
    }
    
    var isComplete: Bool {
        digits.allSatisfy { $0.count == 1 }
    }
    
    var otpString: String {
        digits.joined()
    }
    
    func digit(at index: Int) -> String {
        guard index < digits.count else { return "" }
        return digits[index]
    }
    
    func setDigit(_ value: String, at index: Int) {
        guard index < digits.count else { return }
        let filtered = value.filter { $0.isNumber }
        if filtered.count > 1 {
            // Paste: distribute across fields, 1 char per box
            let chars = Array(filtered.prefix(4))
            for (i, char) in chars.enumerated() where i < digits.count {
                digits[i] = String(char)
            }
            focusedIndex = min(chars.count, 3)
        } else {
            // Single char only - 1 box = 1 digit
            let wasEmpty = digits[index].isEmpty
            digits[index] = String(filtered.prefix(1))
            if !filtered.isEmpty {
                if index < 3 {
                    focusedIndex = index + 1
                } else {
                    // 4th digit entered – remove focus
                    focusedIndex = 4
                }
            } else if filtered.isEmpty && index > 0 {
                // Backspace: focus pichli field pe; agar current pehle se empty tha to pichli bhi clear
                if wasEmpty {
                    digits[index - 1] = ""
                }
                focusedIndex = index - 1
            }
        }
    }
    
    func startTimer() {
        secondsRemaining = 90
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self else { return }
                if self.secondsRemaining > 0 {
                    self.secondsRemaining -= 1
                } else {
                    self.timer?.invalidate()
                }
            }
        }
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    /// Call after resend OTP success to restart countdown from 90 seconds
    func restartTimer() {
        stopTimer()
        startTimer()
    }
}

struct OTPVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        OTPVerificationView(email: "adnan@gmail.com", onBack: {}, onVerified: {})
    }
}
