//
//  ChatListViewModel.swift
//  Tango
//
//  Created by Глеб Бурштейн on 14.05.2021.
//

import Foundation
import Combine
import UIKit

class ChatListViewModel: ObservableObject {
    @Published var searchState = StateSearch.idle
    
    @Published var invitations = [Chat]()
    @Published var chats = [Chat]()
    
    @Published var searchingText = ""
    @Published var isShowingNewChatTab = false
    
    @Published var chatName = ""
    @Published var chatInfo = ""
    @Published var chosenUsers = [Int]()
    @Published var chosenImage: UIImage?
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        $searchingText
            .dropFirst()
            .removeDuplicates()
            .map { str -> String? in
                if (str.count < 1) {
                    self.searchState = .idle
                    return nil
                }
            
                return str
            }
            .compactMap { $0 }
            .sink { query in
                self.searchUsers(query: query)
            }
            .store(in: &subscriptions)
    }
    
    private func searchUsers(query: String) {
        searchState = .loading
        ProfileAPI.shared.searchUsers(query: query)
            .receive(on: RunLoop.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    switch error {
                    case .custom(let msg, _):
                        print(msg)
                    default: print("Some error")
                    }
                }
            } receiveValue: { users in
                self.searchState = .loaded(users: users)
            }
            .store(in: &subscriptions)
    }
    
    public func getChats() {
        ChatAPI.shared.getChats(id: Session.shared.userId, endpoint: .chats)
            .receive(on: RunLoop.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    switch error {
                    case .custom(let msg):
                        print(msg)
                    }
                }
            } receiveValue: { res in
                self.chats = res
            }
            .store(in: &subscriptions)
    }
    
    public func getInvitations() {
        ChatAPI.shared.getChats(id: Session.shared.userId, endpoint: .invitations)
            .receive(on: RunLoop.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    switch error {
                    case .custom(let msg):
                        print(msg)
                    }
                }
            } receiveValue: { res in
                self.invitations = res
            }
            .store(in: &subscriptions)
    }
    
    public func createChat() {
        ChatAPI.shared.createChat(name: chatName, info: chatInfo, users: chosenUsers)
            .receive(on: RunLoop.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    switch error {
                    case .custom(let msg):
                        print(msg)
                    }
                } else {
                    self.isShowingNewChatTab = false
                }
            } receiveValue: { chat in
                self.chats.append(chat)
            }
            .store(in: &subscriptions)
    }
    
    public func editChat() {
        
    }
    
    deinit {
        for subscription in subscriptions {
            subscription.cancel()
        }
    }
}

extension ChatListViewModel {
    enum StateSearch {
        case idle
        case loading
        case loaded(users: [User])
    }
}
