//
//  DataBaseManager.swift
//  Tango
//
//  Created by Глеб Бурштейн on 02.11.2020.
//

import Foundation

class MoviesAPI {
    private let url = URL(string: "")
    
    func getMoviesFromGenre(genre: Int, completion: @escaping ([Movie]) -> ()) {
        guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=d41526ac20f18575a8131958e3298822&with_genres=" + String(genre)) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            let movieResponse = try! JSONDecoder().decode(MovieResponse.self, from: data!)
            
            DispatchQueue.main.async {
                completion(movieResponse.results)
            }
        }
        .resume()
    }
    
    func getGenres(completion: @escaping ([Genre]) -> ()) {
        guard let url = URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=d41526ac20f18575a8131958e3298822&language=en-US") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            let genreResponse = try! JSONDecoder().decode(GenreResponse.self, from: data!)
            
            DispatchQueue.main.async {
                completion(genreResponse.genres)
            }
        }
        .resume()
    }
    
    struct MovieResponse: Codable {
        var page: Int
        var results: [Movie]
        var total_pages: Int
        var total_results: Int
    }
    
    struct GenreResponse: Codable {
        var genres: [Genre]
    }
}
