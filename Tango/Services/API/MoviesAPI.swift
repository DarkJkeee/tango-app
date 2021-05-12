//
//  MoviesAPI.swift
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
    private var subscriptions = Set<AnyCancellable>()
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd"
        jsonDecoder.dateDecodingStrategy = .formatted(formatter)
        return jsonDecoder
    }()
    
    
    func getMovies(from genre: Int) -> Future<[Movie], MoviesAPIError> {
        return Future<[Movie], MoviesAPIError> { [unowned self] promise in
            guard let url = URL(string: "\(url)/discover/movie?api_key=\(apiKey)&with_genres=\(genre)") else {
                return promise(.failure(.urlError(URLError(.unsupportedURL))))
            }
            
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw MoviesAPIError.responseError((response as? HTTPURLResponse)?.statusCode ?? 500)
                    }
                    return data
                }
                .decode(type: MovieResponse.self, decoder: jsonDecoder)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        switch error {
                        case let urlError as URLError:
                            promise(.failure(.urlError(urlError)))
                        case let decodingError as DecodingError:
                            promise(.failure(.decodingError(decodingError)))
                        case let apiError as MoviesAPIError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(.genericError))
                        }
                    }
                }, receiveValue: {
                    promise(.success($0.results))
                })
                .store(in: &subscriptions)
        }
    }
    
    
    func getGenres() -> Future<[Genre], MoviesAPIError> {
        return Future<[Genre], MoviesAPIError> { [unowned self] promise in
            guard let url = URL(string: "\(url)/genre/movie/list?api_key=\(apiKey)&language=en-US") else {
                return promise(.failure(.urlError(URLError(.unsupportedURL))))
            }
            
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw MoviesAPIError.responseError((response as? HTTPURLResponse)?.statusCode ?? 500)
                    }
                    return data
                }
                .decode(type: GenreResponse.self, decoder: jsonDecoder)
                .receive(on: RunLoop.main)
                .sink { (completion) in
                    if case let .failure(error) = completion {
                        switch error {
                        case let urlError as URLError:
                            promise(.failure(.urlError(urlError)))
                        case let decodingError as DecodingError:
                            promise(.failure(.decodingError(decodingError)))
                        case let apiError as MoviesAPIError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(.genericError))
                        }
                    }
                } receiveValue: {
                    promise(.success($0.genres))
                }
                .store(in: &subscriptions)
        }
    }
    
    func getSearchRepsonse(query: String) -> Future<[Movie], MoviesAPIError> {
        
        return Future<[Movie], MoviesAPIError> { [unowned self] promise in
            guard let url = URL(string: "\(url)/search/movie?api_key=\(apiKey)&language=en-US&query=\(query)&page=1&include_adult=false")
            else { return promise(.failure(.urlError(URLError(.unsupportedURL)))) }
            
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw MoviesAPIError.responseError((response as? HTTPURLResponse)?.statusCode ?? 500)
                    }
                    return data
                }
                .decode(type: MovieResponse.self, decoder: jsonDecoder)
                .receive(on: RunLoop.main)
                .sink { completion in
                    if case let .failure(error) = completion {
                        switch error {
                        case let urlError as URLError:
                            promise(.failure(.urlError(urlError)))
                        case let decodingError as DecodingError:
                            promise(.failure(.decodingError(decodingError)))
                        case let apiError as MoviesAPIError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(.genericError))
                        }
                    }
                } receiveValue: {
                    promise(.success($0.results))
                }
                .store(in: &subscriptions)

        }
    }
    
    deinit {
        for subscription in subscriptions {
            subscription.cancel()
        }
    }
    
//    func setMovieToWishlist(movie: Movie) {
//
//        struct Body: Codable {
//            var media_type = "movie"
//            var media_id: Int
//            var watchlist = true
//        }
//
//        let body = Body(media_id: movie.id)
//
//        guard let encoded = try? JSONEncoder().encode(body) else {
//            print("Failed to encode order")
//            return
//        }
//
//        let url = URL(string: "https://api.themoviedb.org/3/account/1/watchlist?api_key=d41526ac20f18575a8131958e3298822")!
//        var request = URLRequest(url: url)
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = "POST"
//        request.httpBody = encoded
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//
//        }.resume()
//
//    }
    
}

struct MovieResponse: Codable {
    var page: Int?
    var results: [Movie]
    var totalPages: Int?
    var totalResults: Int?
}

struct GenreResponse: Codable {
    var genres: [Genre]
}

public enum MoviesAPIError: Error {
    case urlError(URLError)
    case responseError(Int)
    case decodingError(DecodingError)
    case genericError
    
    var localizedDescription: String {
        switch self {
        case .urlError(let error):
            return "Some problem with url: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Some error with decoding: \(error.localizedDescription)"
        case .responseError(let status):
            return "Bad response code: \(status)"
        case .genericError:
            return "An unknown error has been occured"
        }
    }
}
