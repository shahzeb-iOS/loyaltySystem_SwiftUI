//
//  LoggedInUser.swift
//  LoyaltySystem
//
//  User data from login response - used for dashboard and profile
//

import Foundation

struct LoggedInUser {
    let id: String
    let name: String
    let email: String
    let phone: String?
    /// From login API user.membership
    let membership: String?
    /// From login API user.loyalityID
    let loyaltyId: String?
    
    init?(from userData: UserData?) {
        guard let user = userData else { return nil }
        let id = user.id.map { String($0) } ?? "1"
        let name = user.name ?? user.fullName ?? ""
        let email = user.email ?? ""
        self.id = id
        self.name = name
        self.email = email
        self.phone = user.phone
        self.membership = user.membership
        self.loyaltyId = user.loyalityID
    }
    
    init(id: String, name: String, email: String, phone: String? = nil, membership: String? = nil, loyaltyId: String? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.membership = membership
        self.loyaltyId = loyaltyId
    }
}
