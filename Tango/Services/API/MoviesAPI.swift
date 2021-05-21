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
//    private let apiKey = "d41526ac20f18575a8131958e3298822"
//    private let url = "https://api.themoviedb.org/3"
    private let url = "https://tango-server-db-eu.herokuapp.com"
    private var subscriptions = Set<AnyCancellable>()
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd"
        jsonDecoder.dateDecodingStrategy = .formatted(formatter)
        return jsonDecoder
    }()
    
    func GetMovies(from genre: Int?) -> Future<[MovieDTO], MoviesAPIError> {
        return Future<[MovieDTO], MoviesAPIError> { [unowned self] promise in
            let urlStr: String
            
            if genre != nil {
                urlStr = "\(url)/api/film/list?page=0&size=10"
            } else {
                urlStr = "\(url)/api/film/list?page=0&size=10"
            }
            
            guard let url = URL(string: urlStr) else {
                return promise(.failure(.urlError(URLError(.unsupportedURL))))
            }
            
            var request = URLRequest(url: url)
            request.setValue("Bearer \(Session.shared.token)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTaskPublisher(for: request)
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
                    promise(.success($0.result))
                })
                .store(in: &subscriptions)
        }
    }
    
    func getGenres() -> Future<[Genre], MoviesAPIError> {
        return Future<[Genre], MoviesAPIError> { [unowned self] promise in
            guard let url = URL(string: "\(url)/api/common/genres") else {
                return promise(.failure(.urlError(URLError(.unsupportedURL))))
            }
            
            var request = URLRequest(url: url)
            request.setValue("Bearer \(Session.shared.token)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw MoviesAPIError.responseError((response as? HTTPURLResponse)?.statusCode ?? 500)
                    }
                    return data
                }
                .decode(type: [Genre].self, decoder: jsonDecoder)
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
                    promise(.success($0))
                }
                .store(in: &subscriptions)
        }
    }
    
    func getSearchRepsonse(query: String) -> Future<[MovieDTO], MoviesAPIError> {
        
        return Future<[MovieDTO], MoviesAPIError> { [unowned self] promise in
            let url = "\(url)/api/film/list?page=0&size=10&search=\(query)"
            if let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                guard let url = URL(string: urlString)
                else { return promise(.failure(.urlError(URLError(.unsupportedURL)))) }
                
                var request = URLRequest(url: url)
                request.setValue("Bearer \(Session.shared.token)", forHTTPHeaderField: "Authorization")
                
                URLSession.shared.dataTaskPublisher(for: request)
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
                        promise(.success($0.result))
                    }
                    .store(in: &subscriptions)
            }
        }
    }
    
    func getComments(id: Int) -> Future<[Comment], MoviesAPIError> {
        return Future<[Comment], MoviesAPIError> { [unowned self] promise in
            guard let url = URL(string: "\(url)/api/comment/\(id)/list?page=0&size=10")
            else { return promise(.failure(.urlError(URLError(.unsupportedURL)))) }
            
            var request = URLRequest(url: url)
            request.setValue("Bearer \(Session.shared.token)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw MoviesAPIError.responseError((response as? HTTPURLResponse)?.statusCode ?? 500)
                    }
                    return data
                }
                .decode(type: CommentResponse.self, decoder: jsonDecoder)
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
                    promise(.success($0.result))
                }
                .store(in: &subscriptions)

        }
    }
    
    func leaveComment(filmId: Int, userId: Int, text: String) -> Future<Comment, MoviesAPIError> {
        struct Body: Encodable {
            var text: String
            var spoiler: Bool
        }
        
        let body = Body(text: text, spoiler: false)
        
        return Future<Comment, MoviesAPIError> { [unowned self] promise in
            guard let url = URL(string: "\(url)/api/comment/\(filmId)/\(userId)")
            else { return promise(.failure(.urlError(URLError(.unsupportedURL)))) }
            
            var request = URLRequest(url: url)
            request.setValue("Bearer \(Session.shared.token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONEncoder().encode(body)
            request.httpMethod = "POST"
            
            URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw MoviesAPIError.responseError((response as? HTTPURLResponse)?.statusCode ?? 500)
                    }
                    return data
                }
                .decode(type: Comment.self, decoder: jsonDecoder)
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
                    promise(.success($0))
                }
                .store(in: &subscriptions)

        }
    }
    
    public func deleteComment(id: Int) -> Future<String, ProfileError> {
        
        return Future<String, ProfileError> { promise in
            guard let url = URL(string: "\(self.url)/api/comment/\(id)") else {
                return promise(.failure(ProfileError.custom(message: URLError(.unsupportedURL).localizedDescription, status: 500)))
            }
            
            var request = URLRequest(url: url)
            request.setValue("Bearer \(Session.shared.token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "DELETE"
            
            URLSession.shared.dataTaskPublisher(for: request)
                .tryMap({ (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
//                        print(String(data: data, encoding: String.Encoding.utf8))
                        throw ProfileError.custom(message: "Bad response: \((response as? HTTPURLResponse)?.statusCode ?? 500)", status: (response as? HTTPURLResponse)?.statusCode ?? 500)
                    }
                    return data
                })
                .decode(type: DeleteResponse.self, decoder: self.jsonDecoder)
                .receive(on: RunLoop.main)
                .sink { completion in
                    if case let .failure(error) = completion {
                        if let error = error as? ProfileError {
                            promise(.failure(error))
                        } else {
                            promise(.failure(.custom(message: error.localizedDescription, status: 500)))
                        }
                    }
                } receiveValue: { value in
                    promise(.success(value.status))
                }
                .store(in: &self.subscriptions)
        }
    }
    
    deinit {
        for subscription in subscriptions {
            subscription.cancel()
        }
    }
    
}

struct DeleteResponse: Decodable {
    var status: String
}

struct CommentResponse: Decodable {
    var result: [Comment]
    var pagination: Pagination
}

struct Comment: Decodable, Identifiable {
    var id: Int { return commentId }
    
    var writer: User
    var commentId: Int
    var text: String
    var likes: Int
    var dislikes: Int
}


struct MovieResponse: Decodable {
    var result: [MovieDTO]
    var pagination: Pagination
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
