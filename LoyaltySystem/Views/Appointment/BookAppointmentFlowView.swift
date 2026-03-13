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
    /// When opening from a cell (e.g. Catalog), pass that cell's service id and name
    var initialServiceId: String? = nil
    var initialServiceName: String? = nil
    
    @State private var currentStep = 1
    @State private var selectedBranch: String = "San Jerónimo"
    
    private var serviceId: String { initialServiceId ?? "3" }
    private var serviceName: String { initialServiceName ?? "Classic Facial" }
    
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
                    serviceId: serviceId,
                    serviceName: serviceName,
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
        BookAppointmentFlowView(userId: "1", dataService: .shared, onDismiss: {}, initialServiceId: nil, initialServiceName: nil)
    }
}
