//
//  BookAppointmentFlowView.swift
//  LoyaltySystem
//
//  Manages Book Appointment flow: Select Branch -> Date & Time
//

import SwiftUI

struct BookAppointmentFlowView: View {
    let onDismiss: () -> Void
    
    @State private var currentStep = 1
    
    var body: some View {
        Group {
            if currentStep == 1 {
                BookAppointmentView(
                    onBack: onDismiss,
                    onContinue: { currentStep = 2 }
                )
            } else {
                BookAppointmentDateTimeView(
                    onBack: { currentStep = 1 },
                    onConfirm: onDismiss
                )
            }
        }
    }
}

struct BookAppointmentFlowView_Previews: PreviewProvider {
    static var previews: some View {
        BookAppointmentFlowView(onDismiss: {})
    }
}
