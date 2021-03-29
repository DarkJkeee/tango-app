//
//  Person.swift
//  Tango
//
//  Created by Глеб Бурштейн on 25.03.2021.
//

import Foundation

struct Person: Codable, Identifiable {
    var id = UUID()
    var name: String
    
}
