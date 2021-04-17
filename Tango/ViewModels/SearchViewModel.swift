//
//  SearchViewModel.swift
//  Tango
//
//  Created by Глеб Бурштейн on 29.03.2021.
//

import Foundation

final class SearchViewModel: ObservableObject {
    
    @Published var movies = [Movie]()
    
    public func getSearchResponse(query: String) {
        MoviesAPI.shared.getSearchRepsonse(query: query) { (movies) in
            self.movies = movies
        }
    }
}
