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

struct BookAppointmentDateTimeView: View {
    let onBack: () -> Void
    let onConfirm: () -> Void
    
    @State private var selectedDate = Date()
    @State private var showDatePicker = false
    @State private var selectedSlot: String? = "1:00 PM"
    @State private var hasSelectedDate = false
    
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
                        onDismiss: { showDatePicker = false }
                    )
                    .padding(.top, 170)
                    .padding(.horizontal, 20)
                }
            }
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
    
    private var confirmButton: some View {
        Button(action: onConfirm) {
            Text("Confirm Appointment")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.appPrimaryDark)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 20)
        .padding(.top, 50)
    }
}

// MARK: - Custom Calendar Overlay (screen par inline)
struct CustomCalendarOverlay: View {
    @Binding var selectedDate: Date
    @Binding var hasSelectedDate: Bool
    let onDismiss: () -> Void
    
    @State private var displayedMonth: Date
    
    private let calendar = Calendar.current
    private let weekdaySymbols = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    
    init(selectedDate: Binding<Date>, hasSelectedDate: Binding<Bool>, onDismiss: @escaping () -> Void) {
        self._selectedDate = selectedDate
        self._hasSelectedDate = hasSelectedDate
        self.onDismiss = onDismiss
        self._displayedMonth = State(initialValue: selectedDate.wrappedValue)
    }
    
    private var monthYearText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: displayedMonth)
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
    
    var body: some View {
        VStack(spacing: 20) {
            // Month/Year header with arrows
            HStack {
                Button(action: { displayedMonth = calendar.date(byAdding: .month, value: -1, to: displayedMonth) ?? displayedMonth }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.appTextSecondary)
                        .frame(width: 32, height: 32)
                }
                .buttonStyle(.plain)
                
                Spacer()
                
                Text(monthYearText)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Button(action: { displayedMonth = calendar.date(byAdding: .month, value: 1, to: displayedMonth) ?? displayedMonth }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.appTextSecondary)
                        .frame(width: 32, height: 32)
                }
                .buttonStyle(.plain)
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
                        Button(action: {
                            selectedDate = date
                            hasSelectedDate = true
                        }) {
                            Text("\(calendar.component(.day, from: date))")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(selected ? .white : (inMonth ? .black : .appTextSecondary.opacity(0.5)))
                                .frame(width: 36, height: 36)
                                .background(selected ? Color.appAccentGold : Color.clear)
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)
                        .disabled(!inMonth)
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

#Preview {
    BookAppointmentDateTimeView(onBack: {}, onConfirm: {})
}
