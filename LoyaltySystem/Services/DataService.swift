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
    @Published var tiers: [TierItem] = []
    @Published var dashboardPoints: Int?
    @Published var dashboardTierName: String?
    @Published var nextAppointment: DashboardAppointmentItem?
    @Published var currentSpending: Int?
    @Published var nextTierSpending: Int?
    @Published var isLoadingServices = false
    @Published var isLoadingPromotions = false
    @Published var isLoadingAppointments = false
    @Published var isLoadingTiers = false
    @Published var isLoadingDashboard = false
    @Published var isBookingAppointment = false
    @Published var isRedeemingPoints = false
    @Published var lastErrorMessage: String?
    
    private init() {}
    
    func clearLastError() {
        lastErrorMessage = nil
    }
    
    func fetchAllServices() async {
        isLoadingServices = true
        defer { isLoadingServices = false }
        
        let endpoint = APIEndpoint.getAllServices
        do {
            let response: ServicesResponse = try await APIService.shared.request(endpoint)
            services = response.services ?? []
        } catch {
            print("[DataService] getAllServices error: \(error.localizedDescription)")
            lastErrorMessage = error.localizedDescription
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
            lastErrorMessage = error.localizedDescription
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
            lastErrorMessage = error.localizedDescription
            appointments = []
        }
    }
    
    func fetchTiers() async {
        isLoadingTiers = true
        defer { isLoadingTiers = false }
        
        let endpoint = APIEndpoint.getTiers
        do {
            let response: GetTiersResponse = try await APIService.shared.request(endpoint)
            tiers = response.tiers ?? []
        } catch {
            print("[DataService] getTiers error: \(error.localizedDescription)")
            lastErrorMessage = error.localizedDescription
            tiers = []
        }
    }
    
    /// getDashboard – used on Home (dashboard). Populates dashboardPoints, dashboardTierName, nextAppointment.
    func fetchDashboard(userId: String) async {
        isLoadingDashboard = true
        defer { isLoadingDashboard = false }
        
        let endpoint = APIEndpoint.getDashboard(userId: userId)
        do {
            let response: GetDashboardResponse = try await APIService.shared.request(endpoint)
            dashboardPoints = response.points
            dashboardTierName = response.tierName
            nextAppointment = response.nextAppointment
            currentSpending = response.currentSpending ?? response.points
            nextTierSpending = response.nextTierSpending
            if let appointments = response.appointments, !appointments.isEmpty {
                self.appointments = appointments
            }
            if nextTierSpending == nil, let points = response.points {
                nextTierSpending = nextTierPointsRequired(currentPoints: points)
            }
        } catch {
            print("[DataService] getDashboard error: \(error.localizedDescription)")
            lastErrorMessage = error.localizedDescription
            dashboardPoints = nil
            dashboardTierName = nil
            nextAppointment = nil
            currentSpending = nil
            nextTierSpending = nil
        }
    }
    
    /// Next tier's points required (from getTiers). Used for progress bar when API doesn't send nextTierSpending.
    private func nextTierPointsRequired(currentPoints: Int) -> Int? {
        let sorted = (tiers.map { $0.pointsRequired ?? 0 }.filter { $0 > currentPoints }).sorted()
        return sorted.first
    }
    
    /// bookAppointment – used when user confirms appointment in Book Appointment flow.
    func bookAppointment(branchName: String, serviceId: String, userId: String, date: String, time: String) async throws {
        isBookingAppointment = true
        defer { isBookingAppointment = false }
        
        let endpoint = APIEndpoint.bookAppointment(branchName: branchName, serviceId: serviceId, userId: userId, date: date, time: time)
        let _: BookAppointmentResponse = try await APIService.shared.request(endpoint)
    }
    
    /// redeemPoints – used when user taps Redeem in Catalog for a service/product.
    func redeemPoints(userId: String, points: Int) async throws {
        isRedeemingPoints = true
        defer { isRedeemingPoints = false }
        
        let endpoint = APIEndpoint.redeemPoints(userId: userId, points: points)
        let _: RedeemPointsResponse = try await APIService.shared.request(endpoint)
        if let current = dashboardPoints {
            dashboardPoints = max(0, current - points)
        }
    }
}
