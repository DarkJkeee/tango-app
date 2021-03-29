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
    var backdrop_path: String?
    var original_language: String?
    var original_title: String?
    var popularity: Double?
    var vote_average: Double?
    var vote_count: Int?
//    var video: String
    var overview: String
    var genre_ids: [Int]
    var release_date: String
    var adult: Bool
    
//    var duration: Int
    
}

struct Genre: Codable, Identifiable {
    var id: Int
    var name: String
}
