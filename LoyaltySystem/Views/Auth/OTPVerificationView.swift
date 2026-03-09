//
//  OTPVerificationView.swift
//  LoyaltySystem
//
//  OTP Verification - 4 digit fields, Verify button, Resend timer
//

import SwiftUI

struct OTPVerificationView: View {
    @StateObject private var viewModel = OTPViewModel()
    @State private var isVerifying = false
    @State private var verifyError: String?
    let email: String
    let onBack: () -> Void
    let onVerified: () -> Void
    
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
                                .foregroundColor(.appTextPrimary)
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
                    
                    Text("OTP Verification")
                        .font(.appOTPTitle)
                        .foregroundColor(.appTextPrimary)
                    
                    Text("Please check your email \(email) to see the verification code")
                        .font(.appOTPSubtitle)
                        .foregroundColor(.appTextSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 17)
                    
                    Text("OTP Code")
                        .font(.appOTPCodeLabel)
                        .foregroundColor(.appTextPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                    
                    // 4 OTP digit fields
                    HStack(spacing: 16) {
                        ForEach(0..<4, id: \.self) { index in
                            OTPDigitField(
                                digit: binding(for: index),
                                isFocused: viewModel.focusedIndex == index
                            ) {
                                let firstEmpty = viewModel.digits.firstIndex(where: { $0.isEmpty }) ?? index
                                viewModel.focusedIndex = firstEmpty
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    if let err = verifyError {
                        Text(err)
                            .font(.appHint)
                            .foregroundColor(.appErrorText)
                            .padding(.horizontal, 24)
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
                    
                    HStack {
                        Text("Resend code to")
                            .font(.appOTPResend)
                            .foregroundColor(.appTextSecondary)
                        Spacer()
                        Text(viewModel.timerString)
                            .font(.appOTPResend)
                            .foregroundColor(.appTextPrimary)
                            .monospacedDigit()
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.vertical, 24)
            }
        }
        .onAppear { viewModel.startTimer() }
        .onDisappear { viewModel.stopTimer() }
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
}

struct OTPDigitField: View {
    @Binding var digit: String
    let isFocused: Bool
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
            digits[index] = String(filtered.prefix(1))
            if !filtered.isEmpty && index < 3 {
                focusedIndex = index + 1
            } else if filtered.isEmpty && index > 0 {
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
}

struct OTPVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        OTPVerificationView(email: "adnan@gmail.com", onBack: {}, onVerified: {})
    }
}
