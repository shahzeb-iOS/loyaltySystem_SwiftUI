//
//  BookAppointmentFlowView.swift
//  LoyaltySystem
//
//  Manages Book Appointment flow: Select Branch -> Date & Time (calls bookAppointment API on confirm)
//

import SwiftUI

struct BookAppointmentFlowView: View {
    let userId: String
    @ObservedObject var dataService: DataService
    let onDismiss: () -> Void
    
    @State private var currentStep = 1
    @State private var selectedBranch: String = "San Jerónimo"
    
    var body: some View {
        Group {
            if currentStep == 1 {
                BookAppointmentView(
                    selectedBranch: $selectedBranch,
                    onBack: onDismiss,
                    onContinue: { currentStep = 2 }
                )
            } else {
                BookAppointmentDateTimeView(
                    branchName: selectedBranch,
                    serviceId: "3",
                    serviceName: "Classic Facial",
                    userId: userId,
                    dataService: dataService,
                    onBack: { currentStep = 1 },
                    onConfirm: onDismiss
                )
            }
        }
    }
}

struct BookAppointmentFlowView_Previews: PreviewProvider {
    static var previews: some View {
        BookAppointmentFlowView(userId: "1", dataService: .shared, onDismiss: {})
    }
}
