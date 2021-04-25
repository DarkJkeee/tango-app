//
//  Movie.swift
//  Tango
//
//  Created by Глеб Бурштейн on 01.11.2020.
//

import Foundation

struct MovieResponse: Codable {
    var page: Int?
    var results: [Movie]
    var totalPages: Int?
    var totalResults: Int?
}

struct Movie: Codable, Identifiable {
    var id: Int
    var title: String
    var posterPath: String?
    var voteCount: Int
    var voteAverage: Double
//    var video: String
    var releaseDate: Date
    var overview: String
    var genreIds: [Int]
    
    var getReleaseDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y"
        return formatter.string(from: releaseDate)
    }
//    var duration: Int
    
}
