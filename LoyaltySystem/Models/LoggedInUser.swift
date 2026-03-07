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
    
    init?(from userData: UserData?) {
        guard let user = userData else { return nil }
        let id = user.id.map { String($0) } ?? "1"
        let name = user.name ?? user.fullName ?? ""
        let email = user.email ?? ""
        self.id = id
        self.name = name
        self.email = email
        self.phone = user.phone
    }
    
    init(id: String, name: String, email: String, phone: String? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
    }
}
