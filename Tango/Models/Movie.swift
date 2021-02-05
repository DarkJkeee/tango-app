//
//  Movie.swift
//  Tango
//
//  Created by Глеб Бурштейн on 01.11.2020.
//

import Foundation

struct Movie: Identifiable {
    
    var id = UUID()
    var title: String
    var preview: String
    var video: String
    var description: String
    var genre: String
    var tags: [String]
    
}
