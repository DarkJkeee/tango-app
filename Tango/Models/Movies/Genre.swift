//
//  Genre.swift
//  Tango
//
//  Created by Глеб Бурштейн on 24.04.2021.
//

import Foundation

struct Genre: Codable, Identifiable {
    var id: Int { return genreId }
    var genreId: Int
    var genreName: String
}
