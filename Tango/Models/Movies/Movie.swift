//
//  Movie.swift
//  Tango
//
//  Created by Глеб Бурштейн on 01.11.2020.
//

import Foundation

struct Movie: Codable, Identifiable {
    var id: Int { return filmId }
    
    let title: String
    let filmId: Int
    let descRating: Double
    let filmLink: String
    let descImage, descPreview: String
    let descText: String
    
//    var posterPath: String?
//    var voteCount: Int?
//    var voteAverage: Double?
////    var video: String
//    var releaseDate: Date?
//    var overview: String?
//    var genreIds: [Int]?
    
//    var getReleaseDate: String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "d MMM y"
//        return formatter.string(from: releaseDate ?? Date())
//    }
//    var duration: Int
    
}

struct MovieDTO: Codable, Identifiable {
    var id: Int { return film.filmId }
    
    var film: Movie
    var genres: [Genre]
}
