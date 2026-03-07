//
//  DataService.swift
//  LoyaltySystem
//
//  Fetches promotions, services, and user appointments from API
//

import Foundation

@MainActor
final class DataService: ObservableObject {
    static let shared = DataService()
    
    @Published var services: [ServiceItem] = []
    @Published var promotions: [PromotionItem] = []
    @Published var appointments: [AppointmentItem] = []
    @Published var isLoadingServices = false
    @Published var isLoadingPromotions = false
    @Published var isLoadingAppointments = false
    
    private init() {}
    
    func fetchAllServices() async {
        isLoadingServices = true
        defer { isLoadingServices = false }
        
        let endpoint = APIEndpoint.getAllServices
        do {
            let response: ServicesResponse = try await APIService.shared.request(endpoint)
            services = response.services ?? []
        } catch {
            print("[DataService] getAllServices error: \(error.localizedDescription)")
            services = []
        }
    }
    
    func fetchPromotions() async {
        isLoadingPromotions = true
        defer { isLoadingPromotions = false }
        
        let endpoint = APIEndpoint.getPromotions
        do {
            let response: PromotionsResponse = try await APIService.shared.request(endpoint)
            promotions = response.promotions ?? []
        } catch {
            print("[DataService] getPromotions error: \(error.localizedDescription)")
            promotions = []
        }
    }
    
    func fetchUserAppointments(userId: String, status: String = "A") async {
        isLoadingAppointments = true
        defer { isLoadingAppointments = false }
        
        let endpoint = APIEndpoint.getUserAppointments(userId: userId, status: status)
        do {
            let response: UserAppointmentsResponse = try await APIService.shared.request(endpoint)
            appointments = response.appointments ?? []
        } catch {
            print("[DataService] getUserAppointments error: \(error.localizedDescription)")
            appointments = []
        }
    }
}
