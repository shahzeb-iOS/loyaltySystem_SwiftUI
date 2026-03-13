//
//  BookAppointmentDateTimeView.swift
//  LoyaltySystem
//
//  Book Appointment - Date & Time selection screen
//

import SwiftUI

struct TimeSlot: Identifiable {
    let id = UUID()
    let time: String
    let isEnabled: Bool
}

enum PaymentOption: String, CaseIterable {
    case cash = "Via cash"
    case points = "Via points"
}

struct BookAppointmentDateTimeView: View {
    let branchName: String
    let serviceId: String
    let serviceName: String
    let userId: String
    @ObservedObject var dataService: DataService
    let onBack: () -> Void
    let onConfirm: () -> Void
    
    @State private var selectedDate = Date()
    @State private var bookingError: String?
    @State private var showBookingError = false
    @State private var showBookingSuccess = false
    @State private var bookingSuccessMessage: String?
    @State private var showDatePicker = false
    @State private var selectedSlot: String? = nil
    @State private var hasSelectedDate = false
    @State private var selectedPayment: PaymentOption = .cash
    @State private var showPayWithPointsSheet = false
    
    /// Confirm enabled only when both date and time are selected
    private var isConfirmEnabled: Bool {
        hasSelectedDate && selectedSlot != nil
    }
    
    private let timeSlots: [TimeSlot] = [
        TimeSlot(time: "9:00 AM", isEnabled: true),
        TimeSlot(time: "10:00 AM", isEnabled: true),
        TimeSlot(time: "11:00 AM", isEnabled: false),
        TimeSlot(time: "12:00 PM", isEnabled: true),
        TimeSlot(time: "1:00 PM", isEnabled: true),
        TimeSlot(time: "2:00 PM", isEnabled: true),
        TimeSlot(time: "3:00 PM", isEnabled: false),
        TimeSlot(time: "4:00 PM", isEnabled: true)
    ]
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                header
                progressIndicator
                dateTimeSection
                availableSlotsSection
                paymentOptionSection
                confirmButton
                Spacer()
            }
            .background(Color.appBackgroundWhite)
            
            // Calendar overlay - screen par inline dikhega (sheet nahi)
            if showDatePicker {
                ZStack(alignment: .top) {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture { showDatePicker = false }
                    
                    CustomCalendarOverlay(
                        selectedDate: $selectedDate,
                        hasSelectedDate: $hasSelectedDate,
                        mode: .futureOnly,
                        onDismiss: { showDatePicker = false }
                    )
                    .padding(.top, 170)
                    .padding(.horizontal, 20)
                }
            }
        }
        .sheet(isPresented: $showPayWithPointsSheet) {
            PayWithPointsSheet(
                serviceName: serviceName,
                totalCharges: 3500,
                maxPoints: dataService.dashboardPoints ?? 0,
                pointsPerDollar: 10,
                onCancel: { showPayWithPointsSheet = false },
                onConfirm: {
                    showPayWithPointsSheet = false
                    doBookingAndDismiss()
                }
            )
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
                .fill(Color.appAccentGold)
                .frame(maxWidth: .infinity)
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.appTextSecondary.opacity(0.25))
                .frame(maxWidth: .infinity)
        }
        .frame(height: 4)
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
    
    private var dateTimeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Date & Time")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)
            
            Button(action: { showDatePicker = true }) {
                HStack {
                    Text(hasSelectedDate ? selectedDate.formatted(date: .abbreviated, time: .omitted) : "Select Date")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(hasSelectedDate ? .black : .appTextSecondary)
                    Spacer()
                    Image("signUpCalenderIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                .padding(16)
                .background(Color.appLightBeige)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 20)
    }
    
    private var availableSlotsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Available slots")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.appTextSecondary)
            
            Menu {
                ForEach(timeSlots) { slot in
                    if slot.isEnabled {
                        Button(slot.time) {
                            selectedSlot = slot.time
                        }
                    } else {
                        Button(slot.time) {}
                            .disabled(true)
                    }
                }
            } label: {
                HStack {
                    Text(selectedSlot ?? "Select time")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(selectedSlot != nil ? .white : .appTextSecondary)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(selectedSlot != nil ? .white : .appAccentGold)
                }
                .padding(16)
                .background(selectedSlot != nil ? Color.appAccentGold : Color.appLightBeige)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var paymentOptionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Payment")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.appTextSecondary)
            
            VStack(spacing: 10) {
                ForEach(PaymentOption.allCases, id: \.self) { option in
                    paymentRadioRow(option)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
    }
    
    private func paymentRadioRow(_ option: PaymentOption) -> some View {
        let isSelected = selectedPayment == option
        return Button {
            selectedPayment = option
        } label: {
            HStack(spacing: 12) {
                Image(systemName: isSelected ? "circle.inset.filled" : "circle")
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? .appAccentGold : .appTextSecondary)
                Text(option.rawValue)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(14)
            .background(isSelected ? Color.appAccentGold.opacity(0.15) : Color.appLightBeige)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.appAccentGold : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
    
    private var confirmButton: some View {
        Button(action: confirmAppointment) {
            HStack {
                if dataService.isBookingAppointment {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.appAccentGold))
                }
                Text(dataService.isBookingAppointment ? "Booking..." : "Confirm Appointment")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(isConfirmEnabled ? Color.appPrimaryDark : Color.appPrimaryDark.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .disabled(!isConfirmEnabled || dataService.isBookingAppointment)
        .padding(.horizontal, 20)
        .padding(.top, 50)
        .alert("Booking Failed", isPresented: $showBookingError) {
            Button("OK", role: .cancel) { showBookingError = false }
        } message: {
            Text(bookingError ?? "Something went wrong.")
        }
        .alert("Success", isPresented: $showBookingSuccess) {
            Button("OK") {
                showBookingSuccess = false
                bookingSuccessMessage = nil
                onConfirm()
            }
        } message: {
            Text(bookingSuccessMessage ?? "Appointment booked successfully.")
        }
    }
    
    private func confirmAppointment() {
        if selectedPayment == .points {
            showPayWithPointsSheet = true
        } else {
            doBookingAndDismiss()
        }
    }
    
    private func doBookingAndDismiss() {
        guard let slot = selectedSlot else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: selectedDate)
        let timeString = timeSlotTo24Hour(slot)
        let paymentViaValue = selectedPayment == .points ? "points" : "cash"
        Task {
            do {
                let response = try await dataService.bookAppointment(branchName: branchName, serviceId: serviceId, userId: userId, date: dateString, time: timeString, paymentVia: paymentViaValue)
                await dataService.fetchUserAppointments(userId: userId, status: "A")
                await MainActor.run {
                    bookingSuccessMessage = response.message ?? "Appointment booked successfully."
                    showBookingSuccess = true
                }
            } catch {
                await MainActor.run {
                    bookingError = error.localizedDescription
                    showBookingError = true
                }
            }
        }
    }
    
    private func timeSlotTo24Hour(_ slot: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        guard let date = formatter.date(from: slot) else {
            if slot.contains("PM") {
                let parts = slot.replacingOccurrences(of: " PM", with: "").split(separator: ":")
                let h = (Int(parts.first ?? "1") ?? 1) + 12
                let m = parts.count > 1 ? String(parts[1]) : "00"
                return String(format: "%02d:%@", min(h, 23), m)
            }
            return "14:30"
        }
        let out = DateFormatter()
        out.dateFormat = "HH:mm"
        return out.string(from: date)
    }
}

// MARK: - Pay With Points Sheet

struct PayWithPointsSheet: View {
    let serviceName: String
    let totalCharges: Double
    let maxPoints: Int
    let pointsPerDollar: Int
    let onCancel: () -> Void
    let onConfirm: () -> Void
    
    @State private var pointsToUse: Int
    
    init(serviceName: String, totalCharges: Double, maxPoints: Int, pointsPerDollar: Int, onCancel: @escaping () -> Void, onConfirm: @escaping () -> Void) {
        self.serviceName = serviceName
        self.totalCharges = totalCharges
        self.maxPoints = max(0, maxPoints)
        self.pointsPerDollar = max(1, pointsPerDollar)
        self.onCancel = onCancel
        self.onConfirm = onConfirm
        let initial = min(maxPoints, Int(totalCharges) * pointsPerDollar)
        self._pointsToUse = State(initialValue: max(0, initial))
    }
    
    private var pointsValueDollars: Double {
        Double(pointsToUse) / Double(pointsPerDollar)
    }
    
    private var remainingAfterPoints: Double {
        max(0, totalCharges - pointsValueDollars)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Pay With Points")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.black)
                .padding(.top, 24)
                .padding(.bottom, 20)
            
            // Service details card
            VStack(alignment: .leading, spacing: 8) {
                Text(serviceName)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                HStack {
                    Text("Total Charges")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.appTextSecondary)
                    Spacer()
                    Text("\(Int(totalCharges))$")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black)
                }
                HStack {
                    Text("Remaining")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.appTextSecondary)
                    Spacer()
                    Text("\(Int(remainingAfterPoints))$")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.appAccentGold.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.appAccentGold.opacity(0.5), lineWidth: 1)
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            
            // Points to use (only when user has points)
            Text("Points to Use")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
            
            if maxPoints > 0 {
                HStack(spacing: 16) {
                    Button(action: {
                        pointsToUse = max(0, pointsToUse - 10)
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(pointsToUse > 0 ? .appAccentGold : .appTextSecondary.opacity(0.4))
                    }
                    .buttonStyle(.plain)
                    .disabled(pointsToUse <= 0)
                    
                    Text("\(pointsToUse)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                        .frame(minWidth: 80)
                    
                    Button(action: {
                        pointsToUse = min(maxPoints, pointsToUse + 10)
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(pointsToUse < maxPoints ? .appAccentGold : .appTextSecondary.opacity(0.4))
                    }
                    .buttonStyle(.plain)
                    .disabled(pointsToUse >= maxPoints)
                }
                .padding(.vertical, 8)
                .padding(.bottom, 4)
                
                Text("Use Maximum Points \(maxPoints)")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.appTextSecondary)
                    .padding(.bottom, 20)
            } else {
                Text("No points available")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.appTextSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .padding(.bottom, 20)
            }
            
            // Payment summary card
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("You Will Pay")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                    Spacer()
                    Text("\(Int(pointsValueDollars)) $")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.appAccentGold)
                }
                Text("With \(pointsToUse) points (\(pointsPerDollar) pts = 1$)")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.8))
                HStack {
                    Spacer()
                    Text("New Remaining Balance")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.white.opacity(0.8))
                    Text("\(Int(remainingAfterPoints))$")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.appPrimaryDark)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 20)
            .padding(.bottom, 28)
            
            // Buttons
            HStack(spacing: 16) {
                Button(action: onCancel) {
                    Text("Cancel")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.appPrimaryDark)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.appBackgroundWhite)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.appTextSecondary.opacity(0.3), lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
                
                Button(action: onConfirm) {
                    Text("Confirm")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(maxPoints > 0 ? Color.appAccentGold : Color.appTextSecondary.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
                .disabled(maxPoints <= 0)
            }
            .padding(.horizontal, 20)
            
            Spacer(minLength: 0)
        }
        .background(Color.appBackgroundWhite)
    }
}

// MARK: - Custom Calendar Overlay (screen par inline)

enum CalendarMode {
    case pastOnly   // e.g. SignUp DOB – future dates not allowed
    case futureOnly // e.g. Book Appointment – past dates not allowed
}

struct CustomCalendarOverlay: View {
    @Binding var selectedDate: Date
    @Binding var hasSelectedDate: Bool
    let mode: CalendarMode
    let onDismiss: () -> Void
    
    @State private var displayedMonth: Date
    
    private let calendar = Calendar.current
    private let weekdaySymbols = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    
    init(selectedDate: Binding<Date>, hasSelectedDate: Binding<Bool>, mode: CalendarMode, onDismiss: @escaping () -> Void) {
        self._selectedDate = selectedDate
        self._hasSelectedDate = hasSelectedDate
        self.mode = mode
        self.onDismiss = onDismiss
        self._displayedMonth = State(initialValue: selectedDate.wrappedValue)
    }
    
    private var monthYearText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: displayedMonth)
    }
    
    private var startOfToday: Date {
        calendar.startOfDay(for: Date())
    }
    
    private var currentMonthStart: Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: startOfToday)) ?? startOfToday
    }
    
    private var daysInMonth: [Date?] {
        guard let range = calendar.range(of: .day, in: .month, for: displayedMonth),
              let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: displayedMonth)) else {
            return []
        }
        let firstWeekday = calendar.component(.weekday, from: firstDay) - 1
        var days: [Date?] = Array(repeating: nil, count: firstWeekday)
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDay) {
                days.append(date)
            }
        }
        let remainder = days.count % 7
        if remainder != 0 {
            days += Array(repeating: nil, count: 7 - remainder)
        }
        return days
    }
    
    private func isSelected(_ date: Date?) -> Bool {
        guard let date = date else { return false }
        return calendar.isDate(date, inSameDayAs: selectedDate)
    }
    
    private func isCurrentMonth(_ date: Date?) -> Bool {
        guard let date = date else { return false }
        return calendar.isDate(date, equalTo: displayedMonth, toGranularity: .month)
    }
    
    private func isDateDisabled(_ date: Date) -> Bool {
        let dayStart = calendar.startOfDay(for: date)
        switch mode {
        case .pastOnly:
            // For SignUp DOB: disallow future dates
            return dayStart > startOfToday
        case .futureOnly:
            // For Book Appointment: disallow past dates
            return dayStart < startOfToday
        }
    }
    
    private var canGoToPreviousMonth: Bool {
        let comparison = calendar.compare(displayedMonth, to: currentMonthStart, toGranularity: .month)
        switch mode {
        case .pastOnly:
            // Can always go to previous months when picking DOB
            return true
        case .futureOnly:
            // For appointments: can't go before current month
            return comparison == .orderedDescending
        }
    }
    
    private var canGoToNextMonth: Bool {
        let comparison = calendar.compare(displayedMonth, to: currentMonthStart, toGranularity: .month)
        switch mode {
        case .pastOnly:
            // For DOB: can't go beyond current month
            return comparison == .orderedAscending
        case .futureOnly:
            // For appointments: can go to any future month
            return true
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Month/Year header with arrows
            HStack {
                Button(action: {
                    guard canGoToPreviousMonth else { return }
                    displayedMonth = calendar.date(byAdding: .month, value: -1, to: displayedMonth) ?? displayedMonth
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(canGoToPreviousMonth ? .appTextSecondary : .appTextSecondary.opacity(0.3))
                        .frame(width: 32, height: 32)
                }
                .buttonStyle(.plain)
                .disabled(!canGoToPreviousMonth)
                
                Spacer()
                
                Text(monthYearText)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Button(action: {
                    guard canGoToNextMonth else { return }
                    displayedMonth = calendar.date(byAdding: .month, value: 1, to: displayedMonth) ?? displayedMonth
                }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(canGoToNextMonth ? .appTextSecondary : .appTextSecondary.opacity(0.3))
                        .frame(width: 32, height: 32)
                }
                .buttonStyle(.plain)
                .disabled(!canGoToNextMonth)
            }
            .padding(.horizontal, 8)
            
            // Weekday labels
            HStack(spacing: 0) {
                ForEach(weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.appTextSecondary)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Date grid
            let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(Array(daysInMonth.enumerated()), id: \.offset) { _, date in
                    if let date = date {
                        let selected = isSelected(date)
                        let inMonth = isCurrentMonth(date)
                        let disabled = !inMonth || isDateDisabled(date)
                        Button(action: {
                            guard !disabled else { return }
                            selectedDate = date
                            hasSelectedDate = true
                        }) {
                            Text("\(calendar.component(.day, from: date))")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(
                                    selected ? .white :
                                        (disabled ? .appTextSecondary.opacity(0.3) : .black)
                                )
                                .frame(width: 36, height: 36)
                                .background(selected ? Color.appAccentGold : Color.clear)
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)
                        .disabled(disabled)
                    } else {
                        Color.clear
                            .frame(width: 36, height: 36)
                    }
                }
            }
            
            // OK button
            Button(action: {
                hasSelectedDate = true
                onDismiss()
            }) {
                Text("OK")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.appPrimaryDark)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
        }
        .padding(24)
        .background(Color.appBackgroundWhite)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct BookAppointmentDateTimeView_Previews: PreviewProvider {
    static var previews: some View {
        BookAppointmentDateTimeView(branchName: "Downtown Clinic", serviceId: "3", serviceName: "Classic Facial", userId: "1", dataService: .shared, onBack: {}, onConfirm: {})
    }
}
