//
//  ChatAPI.swift
//  Tango
//
//  Created by Глеб Бурштейн on 14.05.2021.
//

import Foundation
import Combine

class ChatAPI {
    public static let shared = ChatAPI()
    private init() {}
    private var subscriptions = Set<AnyCancellable>()
    private var url = "https://tango-server-db-eu.herokuapp.com"
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
    
    public func getChats(id: Int, endpoint: Endpoint) -> Future<[Chat], ChatError> {
        return Future<[Chat], ChatError> { promise in
            var stringURL: String
            
            switch endpoint {
                case .chats:
                    stringURL = "\(self.url)/api/chats?page=0&size=10&user_id=\(id)"
                case .invitations:
                    stringURL = "\(self.url)/api/chats/user/invitations?user_id=\(id)&page=0&size=10"
            }
            
            guard let url = URL(string: stringURL) else {
                return promise(.failure(ChatError.custom(msg: URLError(.unsupportedURL).localizedDescription)))
            }
            
            var request = URLRequest(url: url)
            request.setValue("Bearer \(Session.shared.token)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTaskPublisher(for: request)
                .tryMap({ (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw ChatError.custom(msg: "Bad response: \((response as? HTTPURLResponse)?.statusCode ?? 500)")
                    }
                    return data
                })
                .decode(type: GetResponse.self, decoder: self.jsonDecoder)
                .receive(on: RunLoop.main)
                .sink { completion in
                    if case let .failure(error) = completion {
                        if let error = error as? ChatError {
                            promise(.failure(error))
                        } else {
                            promise(.failure(.custom(msg: error.localizedDescription)))
                        }
                    }
                } receiveValue: { res in
                    promise(.success(res.result))
                }
                .store(in: &self.subscriptions)
                
        }
    }
    
    public func createChat(name: String, info: String, users: [Int]) -> Future<Chat, ChatError> {
        let body = CreateChatBody(userId: Session.shared.userId, name: name, info: info, startedUsers: users)
        return Future<Chat, ChatError> { promise in
            guard let url = URL(string: "\(self.url)/api/chats") else {
                return promise(.failure(ChatError.custom(msg: URLError(.unsupportedURL).localizedDescription)))
            }
            
            var request = URLRequest(url: url)
            request.setValue("Bearer \(Session.shared.token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = try? JSONEncoder().encode(body)
            
            URLSession.shared.dataTaskPublisher(for: request)
                .tryMap({ (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw ChatError.custom(msg: "Bad response: \((response as? HTTPURLResponse)?.statusCode ?? 500)")
                    }
                    return data
                })
                .decode(type: Chat.self, decoder: self.jsonDecoder)
                .receive(on: RunLoop.main)
                .sink { completion in
                    if case let .failure(error) = completion {
                        if let error = error as? ChatError {
                            promise(.failure(error))
                        } else {
                            promise(.failure(.custom(msg: error.localizedDescription)))
                        }
                    }
                } receiveValue: { res in
                    promise(.success(res))
                }
                .store(in: &self.subscriptions)
                
        }
    }
    
    public func getHistory(id: Int) -> Future<[MessageDTO], ChatError> {
        return Future<[MessageDTO], ChatError> { promise in
            guard let url = URL(string: "\(self.url)/api/chats/history/\(id)?page=0&size=100") else {
                return promise(.failure(ChatError.custom(msg: URLError(.unsupportedURL).localizedDescription)))
            }
            
            var request = URLRequest(url: url)
            request.setValue("Bearer \(Session.shared.token)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTaskPublisher(for: request)
                .tryMap({ (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw ChatError.custom(msg: "Bad response: \((response as? HTTPURLResponse)?.statusCode ?? 500)")
                    }
                    return data
                })
                .decode(type: HistoryResponse.self, decoder: self.jsonDecoder)
                .receive(on: RunLoop.main)
                .sink { completion in
                    if case let .failure(error) = completion {
                        if let error = error as? ChatError {
                            promise(.failure(error))
                        } else {
                            promise(.failure(.custom(msg: error.localizedDescription)))
                        }
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
    
    struct CreateChatBody: Encodable {
        var userId: Int
        var name: String
        var info: String
        var avatar: String?
        var startedUsers: [Int]
    }

    struct GetResponse: Decodable {
        var result: [Chat]
        var pagination: Pagination
    }
    
    enum Endpoint {
        case invitations
        case chats
    }
}

enum ChatError: Error {
    case custom(msg: String)
}
