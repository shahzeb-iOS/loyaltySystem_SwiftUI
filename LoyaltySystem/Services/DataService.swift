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
    @Published var latestPromotion: LatestPromotionItem?
    @Published var notifications: [NotificationApiItem] = []
    @Published var isLoadingNotifications = false
    @Published var isLoadingServices = false
    @Published var isLoadingPromotions = false
    @Published var isLoadingAppointments = false
    @Published var isLoadingTiers = false
    @Published var isLoadingDashboard = false
    @Published var isBookingAppointment = false
    @Published var isRedeemingPoints = false
    @Published var lastErrorMessage: String?
    @Published var nextTier: String?
    @Published var currentTier: String?
    
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
    
    /// getDashboard – used on Home (dashboard). Populates from response.data: totalSpendings, points, userTier, upcomingAppointment.
    func fetchDashboard(userId: String) async {
        isLoadingDashboard = true
        defer { isLoadingDashboard = false }
        
        let endpoint = APIEndpoint.getDashboard(userId: userId)
        do {
            let response: GetDashboardResponse = try await APIService.shared.request(endpoint)
            let data = response.data
            dashboardPoints = data?.points
            dashboardTierName = data?.userTier?.currentTier
            currentSpending = data?.totalSpendings ?? data?.points 
            nextTierSpending = data?.userTier?.nextTierSpendings.flatMap { Int($0) }
            nextTier = data?.userTier?.nextTier 
            currentTier = data?.userTier?.currentTier
            if nextTierSpending == nil, let cur = data?.totalSpendings {
                nextTierSpending = nextTierPointsRequired(currentPoints: cur)
            }
            if let up = data?.upcomingAppointment {
                nextAppointment = DashboardAppointmentItem(
                    id: up.id,
                    serviceName: up.title,
                    location: up.branchName,
                    branchName: up.branchName,
                    status: nil,
                    date: up.date,
                    time: up.time,
                    points: nil
                )
            } else {
                nextAppointment = nil
            }
            latestPromotion = data?.latestPromotion
        } catch {
            print("[DataService] getDashboard error: \(error.localizedDescription)")
            lastErrorMessage = error.localizedDescription
            dashboardPoints = nil
            dashboardTierName = nil
            nextAppointment = nil
            currentSpending = nil
            nextTierSpending = nil
            latestPromotion = nil
        }
    }
    
    /// getNotifications – fetches notifications for the user.
    func fetchNotifications(userId: String) async {
        isLoadingNotifications = true
        defer { isLoadingNotifications = false }
        
        let endpoint = APIEndpoint.getNotifications(userId: userId)
        do {
            let response: GetNotificationsResponse = try await APIService.shared.request(endpoint)
            notifications = response.notifications ?? []
        } catch {
            print("[DataService] getNotifications error: \(error.localizedDescription)")
            lastErrorMessage = error.localizedDescription
            notifications = []
        }
    }
    
    /// Next tier's points required (from getTiers). Used for progress bar when API doesn't send nextTierSpending.
    private func nextTierPointsRequired(currentPoints: Int) -> Int? {
        let sorted = (tiers.map { $0.pointsRequired ?? 0 }.filter { $0 > currentPoints }).sorted()
        return sorted.first
    }
    
    /// bookAppointment – used when user confirms appointment in Book Appointment flow. Returns API response for success message.
    /// date should be dd/MM/yyyy; paymentVia e.g. "cash" or "points"
    func bookAppointment(branchName: String, serviceId: String, userId: String, date: String, time: String, paymentVia: String) async throws -> BookAppointmentResponse {
        isBookingAppointment = true
        defer { isBookingAppointment = false }
        
        let endpoint = APIEndpoint.bookAppointment(branchName: branchName, serviceId: serviceId, userId: userId, date: date, time: time, paymentVia: paymentVia)
        return try await APIService.shared.request(endpoint)
    }
    
    /// deleteAccount – deletes user account. On success caller should sign out.
    func deleteAccount(userId: String) async throws {
        let endpoint = APIEndpoint.deleteAccount(userId: userId)
        let _: MessageResponse = try await APIService.shared.request(endpoint)
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
