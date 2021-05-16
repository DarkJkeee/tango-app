//
//  User.swift
//  Tango
//
//  Created by Глеб Бурштейн on 02.11.2020.
//

import Foundation

struct User: Codable, Identifiable {
    var id: Int { return userId }
    
    
    var userId: Int
    var username: String
    var email: String
    var age: Int?
    var userRoles: [Role]?
    var avatar: String?
    var favorite: [Movie]
    
//    var dateOfBirth: Date
//    var followers: [User]
//    var following: [User]
//    var subscriptionPlan: Int
//    var favouritesMovies: [Int]
    
    
}

struct Role: Codable {
    var name: String
}
