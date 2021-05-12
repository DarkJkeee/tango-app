//
//  ProfileAPI.swift
//  Tango
//
//  Created by Глеб Бурштейн on 08.05.2021.
//

import SwiftUI
import Combine

class ProfileAPI {
    @AppStorage("jwt_token") var token = ""
    public static let shared = ProfileAPI()
    private init() {}
    private var subscriptions = Set<AnyCancellable>()
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
    
    
    public func loadProfile(with id: Int) -> Future<User, ProfileError> {
        return Future<User, ProfileError> { promise in
            guard let url = URL(string: "https://tango-server-db.herokuapp.com/api/user/\(id)/info") else {
                return promise(.failure(ProfileError.custom(message: URLError(.unsupportedURL).localizedDescription)))
            }
            
            var request = URLRequest(url: url)
            request.setValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTaskPublisher(for: request)
                .tryMap({ (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw ProfileError.custom(message: "Bad response: \((response as? HTTPURLResponse)?.statusCode ?? 500)")
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
                            promise(.failure(.custom(message: error.localizedDescription)))
                        }
                    }
                } receiveValue: { user in
                    promise(.success(user))
                }
                .store(in: &self.subscriptions)
        }
        
    }
    
    
    deinit {
        for sub in subscriptions {
            sub.cancel()
        }
    }
}


enum ProfileError: Error {
    case custom(message: String)
}
