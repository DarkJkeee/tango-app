//
//  User.swift
//  Tango
//
//  Created by Глеб Бурштейн on 02.11.2020.
//

import Foundation

struct User {
    
    var userName: String
    var email: String
    var password: String
    var dateOfBirth: Date
    var followers: [User]
    var following: [User]
    var subscriptionPlan: Int
    
}
