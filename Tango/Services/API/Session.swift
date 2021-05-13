//
//  SessionAPI.swift
//  Tango
//
//  Created by Глеб Бурштейн on 02.05.2021.
//

import Foundation
import Combine
import SwiftUI

class Session {
    public static let shared = Session()
    
    // User defaults storage.
    @AppStorage("expiration_date") private(set) var expireAt = ""
    @AppStorage("jwt_token") private(set) var token = ""
    @AppStorage("user_id") private(set) var userId = -1
    
    private var subscriptions = Set<AnyCancellable>()
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
    
    private init() {}
    
    public func login(email: String, password: String) -> Future<SessionResponse, SessionError> {
        let body = LoginBody(username: email, password: password)
        
        return Future<SessionResponse, SessionError> { promise in
            guard let url = URL(string: "https://tango-server-db.herokuapp.com/auth/login") else {
                return promise(.failure(SessionError.custom(msg: URLError(.unsupportedURL).localizedDescription)))
            }
            
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = try? JSONEncoder().encode(body)
            
            URLSession.shared.dataTaskPublisher(for: request)
                .tryMap({ (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        if (response as? HTTPURLResponse)?.statusCode == 401 {
                            throw SessionError.invalidCredentials
                        }
                        throw SessionError.custom(msg: "Bad response: \((response as? HTTPURLResponse)?.statusCode ?? 500)")
                    }
                    return data
                })
                .decode(type: SessionResponse.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink { completion in
                    if case let .failure(error) = completion {
                        if let error = error as? SessionError {
                            promise(.failure(error))
                        } else {
                            promise(.failure(.custom(msg: error.localizedDescription)))
                        }
                    }
                } receiveValue: { response in
                    self.expireAt = response.expiration
                    self.token = response.jwtToken
                    self.userId = response.user.id
                    promise(.success(response))
                }
                .store(in: &self.subscriptions)
        }
    }
    
    public func register(email: String, username: String, password: String) -> Future<RegistrationResponse, SessionError> {
        let body = RegisterBody(email: email, username: username, password: password, roles: ["ROLE_USER"], date_of_birth: "2002-08-19", sub_deadline: "2021-08-19")
        
        return Future<RegistrationResponse, SessionError> { promise in
            guard let url = URL(string: "https://tango-server-db.herokuapp.com/auth/register") else {
                return promise(.failure(.custom(msg: URLError(.unsupportedURL).localizedDescription)))
            }
            
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = try? JSONEncoder().encode(body)
            
            URLSession.shared.dataTaskPublisher(for: request)
                .tryMap({ (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        if (response as? HTTPURLResponse)?.statusCode == 400 {
                            throw SessionError.usernameExist
                        }
                        throw SessionError.custom(msg: "Bad response: \((response as? HTTPURLResponse)?.statusCode ?? 500)")
                    }
                    return data
                })
                .decode(type: RegistrationResponse.self, decoder: self.jsonDecoder)
                .receive(on: RunLoop.main)
                .sink { completion in
                    if case let .failure(error) = completion {
                        if let error = error as? SessionError {
                            promise(.failure(error))
                        } else {
                            promise(.failure(.custom(msg: error.localizedDescription)))
                        }
                    }
                } receiveValue: { response in
                    promise(.success(response))
                }
                .store(in: &self.subscriptions)
        }
    }
    
    public func changeToken(token: String, expiration: String) {
        self.token = token
        self.expireAt = expiration
    }
    
    public func logout() {
        token = ""
        expireAt = ""
        userId = -1
    }
    
    deinit {
        for sub in subscriptions {
            sub.cancel()
        }
    }
}

struct SessionResponse: Decodable {
    var jwtToken: String
    var user: UserResponse
    var expiration: String
    var issuedAt: String
    
    struct UserResponse: Decodable {
        var id: Int
    }
}

struct RegistrationResponse: Decodable {
    var message: String
    var jwtToken: String
    var user: User
}

struct LoginBody: Encodable {
    var username: String
    var password: String
}

struct RegisterBody: Encodable {
    var email: String
    var username: String
    var password: String
    var roles: [String]
    var date_of_birth: String
    var sub_deadline: String
}


public enum SessionError: Error {
    case usernameExist
    case invalidCredentials
    case custom(msg: String)
}
