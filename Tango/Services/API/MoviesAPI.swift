//
//  DataBaseManager.swift
//  Tango
//
//  Created by Глеб Бурштейн on 02.11.2020.
//

import Foundation
import Combine

class MoviesAPI {
    public static let shared = MoviesAPI()
    private init() {}
    private let apiKey = "d41526ac20f18575a8131958e3298822"
    private let url = "https://api.themoviedb.org/3"
    private let subscriptions = Set<AnyCancellable>()
    
    
    func getSessionId(completion: @escaping (Response) -> ()) {
        
        guard let url = URL(string: "\(url)/authentication/guest_session/new?api_key=\(apiKey)") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            let response = try! JSONDecoder().decode(Response.self, from: data!)
            
            DispatchQueue.main.async {
                completion(response)
            }
        }
        .resume()
    }
    
    func getMoviesFromGenre(genre: Int, completion: @escaping ([Movie]) -> ()) {
        guard let url = URL(string: "\(url)/discover/movie?api_key=\(apiKey)&with_genres=\(genre)") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            let movieResponse = try! JSONDecoder().decode(MovieResponse.self, from: data!)
            
            DispatchQueue.main.async {
                completion(movieResponse.results ?? [])
            }
        }
        .resume()
    }
    
    func getGenres(completion: @escaping ([Genre]) -> ()) {
        guard let url = URL(string: "\(url)/genre/movie/list?api_key=\(apiKey)&language=en-US") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            let genreResponse = try! JSONDecoder().decode(GenreResponse.self, from: data!)
            
            DispatchQueue.main.async {
                completion(genreResponse.genres)
            }
        }
        .resume()
    }
    
    func getSearchRepsonse(query: String, completion: @escaping ([Movie]) -> ()) {
        guard let url = URL(string: "\(url)/search/movie?api_key=\(apiKey)&language=en-US&query=\(query)&page=1&include_adult=false")
        else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            let movieResponse = try! JSONDecoder().decode(MovieResponse.self, from: data!)
            
            DispatchQueue.main.async {
                completion(movieResponse.results ?? [])
            }
        }
        .resume()
    }
    
    func setMovieToWishlist(movie: Movie) {
        
        struct Body: Codable {
            var media_type = "movie"
            var media_id: Int
            var watchlist = true
        }
        
        let body = Body(media_id: movie.id)
        
        guard let encoded = try? JSONEncoder().encode(body) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://api.themoviedb.org/3/account/1/watchlist?api_key=d41526ac20f18575a8131958e3298822")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
        }.resume()
        
    }
    
    
    struct MovieResponse: Codable {
        var page: Int?
        var results: [Movie]?
        var totalPages: Int?
        var totalResults: Int?
    }
    
    struct GenreResponse: Codable {
        var genres: [Genre]
    }
    
    struct Response: Codable {
        var guest_session_id: String
    }
}
