//
//  SessionAPI.swift
//  Tango
//
//  Created by Глеб Бурштейн on 02.05.2021.
//

import Foundation
import Combine

class SessionAPI {
    public static let shared = SessionAPI()
    private var subscriptions = Set<AnyCancellable>()
//    private let jsonDecoder: JSONDecoder = {
//        let jsonDecoder = JSONDecoder()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
//        jsonDecoder.dateDecodingStrategy = .formatted(formatter)
//        return jsonDecoder
//    }()
    private init() {}
    
    public func login(email: String, password: String) -> Future<LoginResponse, SessionError> {
        let body = LoginBody(username: email, password: password)
        
        return Future<LoginResponse, SessionError> { promise in
            guard let url = URL(string: "https://tango-server-db.herokuapp.com/auth/user/login") else {
                return promise(.failure(.custom(msg: URLError(.unsupportedURL).localizedDescription)))
            }
            
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = try? JSONEncoder().encode(body)
            
            URLSession.shared.dataTaskPublisher(for: request)
                .tryMap({ (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        if (response as? HTTPURLResponse)?.statusCode == 403 {
                            promise(.failure(.invalidCredentials))
                        }
                        promise(.failure(.custom(msg: "Bad response: \((response as? HTTPURLResponse)?.statusCode ?? 500)")))
                        throw SessionError.custom(msg: "")
                    }
                    return data
                })
                .decode(type: LoginResponse.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink { completion in
                    if case let .failure(error) = completion {
                        print("Session error: \(error.localizedDescription)")
                        promise(.failure(.custom(msg: "Something went wrong!")))
                    }
                } receiveValue: { response in
                    promise(.success(response))
                }
                .store(in: &self.subscriptions)
        }
    }
    
    public func register() {
        
    }
}

struct LoginResponse: Decodable {
    var jwtToken: String
    var userId: Int
    var expiration: String
    var issuedAt: String
}

struct LoginBody: Encodable {
    var username: String
    var password: String
}

public enum SessionError: Error {
    case invalidCredentials
    case custom(msg: String)
}
