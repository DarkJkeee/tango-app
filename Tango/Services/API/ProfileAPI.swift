//
//  ProfileAPI.swift
//  Tango
//
//  Created by Глеб Бурштейн on 08.05.2021.
//

import Foundation
import Combine

class ProfileAPI {
    public static let shared = ProfileAPI()
    private init() {}
    private var url = "https://tango-server-db-eu.herokuapp.com"
    private var subscriptions = Set<AnyCancellable>()
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
    
    public func favouriteFilm(id: Int, method: String) -> Future<User, ProfileError> {
        return Future<User, ProfileError> { promise in
            guard let url = URL(string: "\(self.url)/api/film/\(id)/favorite/\(Session.shared.userId)") else {
                return promise(.failure(ProfileError.custom(message: URLError(.unsupportedURL).localizedDescription, status: 500)))
            }
            
            var request = URLRequest(url: url)
            request.setValue("Bearer \(Session.shared.token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = method
            
            URLSession.shared.dataTaskPublisher(for: request)
                .tryMap({ (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
//                        print(String(data: data, encoding: String.Encoding.utf8))
                        throw ProfileError.custom(message: "Bad response: \((response as? HTTPURLResponse)?.statusCode ?? 500)", status: (response as? HTTPURLResponse)?.statusCode ?? 500)
                    }
                    return data
                })
                .decode(type: User.self, decoder: self.jsonDecoder)
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
                    promise(.success(value))
                }
                .store(in: &self.subscriptions)
        }
    }
    
    public func loadProfile(with id: Int) -> Future<User, ProfileError> {
        return Future<User, ProfileError> { promise in
            guard let url = URL(string: "\(self.url)/api/user/\(id)/info") else {
                return promise(.failure(ProfileError.custom(message: URLError(.unsupportedURL).localizedDescription, status: 500)))
            }
            
            var request = URLRequest(url: url)
            request.setValue("Bearer \(Session.shared.token)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTaskPublisher(for: request)
                .tryMap({ (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw ProfileError.custom(message: "Bad response: \((response as? HTTPURLResponse)?.statusCode ?? 500)", status: (response as? HTTPURLResponse)?.statusCode ?? 500)
                    }
                    return data
                })
                .decode(type: User.self, decoder: self.jsonDecoder)
                .receive(on: RunLoop.main)
                .sink { completion in
                    if case let .failure(error) = completion {
                        if let error = error as? ProfileError {
                            promise(.failure(error))
                        } else {
                            promise(.failure(.custom(message: error.localizedDescription, status: 500)))
                        }
                    }
                } receiveValue: { user in
                    promise(.success(user))
                }
                .store(in: &self.subscriptions)
        }
        
    }
    
    public func changeProfile(with id: Int, field: String, value: String) -> Future<User, ProfileError> {
        
        var body = EditBody()
        switch field {
        case "username":
            body.username = value
        case "email":
            body.email = value
        case "avatar":
            body.avatar = value
        default:
            break
        }
        
        return Future<User, ProfileError> { promise in
            guard let url = URL(string: "\(self.url)/api/user/\(id)") else {
                return promise(.failure(ProfileError.custom(message: URLError(.unsupportedURL).localizedDescription, status: 500)))
            }
            
            var request = URLRequest(url: url)
            request.setValue("Bearer \(Session.shared.token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "PUT"
            request.httpBody = try? JSONEncoder().encode(body)
            
            URLSession.shared.dataTaskPublisher(for: request)
                .tryMap({ (data, response) -> Data in
                    
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        
//                        print(String(data: data, encoding: String.Encoding.utf8))
                        
                        if (response as? HTTPURLResponse)?.statusCode == 400 {
                            throw ProfileError.exist
                        }
                        throw ProfileError.custom(message: "Bad response: \((response as? HTTPURLResponse)?.statusCode ?? 500)", status: (response as? HTTPURLResponse)?.statusCode ?? 500)
                    }
                    return data
                })
                .decode(type: EditResponse.self, decoder: self.jsonDecoder)
                .receive(on: RunLoop.main)
                .sink { completion in
                    if case let .failure(error) = completion {
                        if let error = error as? ProfileError {
                            promise(.failure(error))
                        } else {
                            promise(.failure(.custom(message: error.localizedDescription, status: 500)))
                        }
                    }
                } receiveValue: { res in
                    promise(.success(res.user))
                    Session.shared.changeToken(token: res.jwtToken, expiration: res.expiration)
                }
                .store(in: &self.subscriptions)
        }
    }
    
    public func deleteUser(id: Int) -> Future<String, ProfileError> {
        
        return Future<String, ProfileError> { promise in
            guard let url = URL(string: "\(self.url)/api/user/\(id)") else {
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
    
    public func searchUsers(query: String) -> Future<[User], ProfileError> {
        return Future<[User], ProfileError> { promise in
            guard let url = URL(string: "\(self.url)/api/user/list?page=0&size=5&search=\(query)") else {
                return promise(.failure(ProfileError.custom(message: URLError(.unsupportedURL).localizedDescription, status: 500)))
            }
            
            var request = URLRequest(url: url)
            request.setValue("Bearer \(Session.shared.token)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw ProfileError.custom(message: "Bad response: \((response as? HTTPURLResponse)?.statusCode ?? 500)", status: (response as? HTTPURLResponse)?.statusCode ?? 500)
                    }
                    return data
                }
                .decode(type: SearchResponse.self, decoder: self.jsonDecoder)
                .receive(on: RunLoop.main)
                .sink { completion in
                    if case let . failure(error) = completion {
                        promise(.failure(.custom(message: error.localizedDescription, status: 500)))
                    }
                } receiveValue: { res in
                    promise(.success(res.result))
                }
                .store(in: &self.subscriptions)
        }
    }
    
    deinit {
        for sub in subscriptions {
            sub.cancel()
        }
    }
    
    struct SearchResponse: Decodable {
        var result: [User]
        var pagination: Pagination
    }

    struct DeleteResponse: Decodable {
        var status: String
    }

    struct EditResponse: Decodable {
        var success: Bool
        var user: User
        var jwtToken: String
        var expiration: String
    }

    struct EditBody: Encodable {
        var username: String?
        var password: String?
        var email: String?
        var avatar: String?
    }

}


struct Pagination: Decodable {
    var page: Int
    var size: Int
    var count: Int
}

enum ProfileError: Error {
    case exist
    case custom(message: String, status: Int)
}
