//
//  Genre.swift
//  Tango
//
//  Created by Глеб Бурштейн on 24.04.2021.
//

import Foundation

struct GenreResponse: Codable {
    var genres: [Genre]
}

struct Genre: Codable, Identifiable {
    var id: Int
    var name: String
}
