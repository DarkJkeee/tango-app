//
//  Movie.swift
//  Tango
//
//  Created by Глеб Бурштейн on 01.11.2020.
//

import Foundation

struct Movie: Codable, Identifiable {
    var id: Int
    var title: String
    var poster_path: String?
    var vote_count: Int?
//    var video: String
    var overview: String
    var genre_ids: [Int]
    
//    var duration: Int
    
}

struct Genre: Codable, Identifiable {
    var id: Int
    var name: String
}
