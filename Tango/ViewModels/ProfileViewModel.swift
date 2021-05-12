//
//  ProfileViewModel.swift
//  Tango
//
//  Created by Глеб Бурштейн on 08.05.2021.
//

import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    @Published var mainUser = User(userId: -1, username: "Unknown", email: "", age: 0, userRoles: [])
    
    @Published var currentUser = User(userId: -1, username: "Unknown", email: "", age: 0, userRoles: [])
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(id: Int) {
        ProfileAPI.shared.loadProfile(with: id)
            .receive(on: RunLoop.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    switch error {
                    case .custom(let message):
                        print(message)
                    }
                }
            } receiveValue: { user in
                self.mainUser.userId = user.userId
                self.mainUser.username = user.username
                self.mainUser.email = user.email
                self.mainUser.age = user.age
                self.mainUser.userRoles = user.userRoles
            }
            .store(in: &subscriptions)
    }
    
    func loadProfileWith(id: Int) {
        ProfileAPI.shared.loadProfile(with: id)
            .receive(on: RunLoop.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    switch error {
                    case .custom(let message):
                        print(message)
                    }
                }
            } receiveValue: { user in
                self.currentUser.userId = user.userId
                self.currentUser.username = user.username
                self.currentUser.email = user.email
                self.currentUser.age = user.age
                self.currentUser.userRoles = user.userRoles
            }
            .store(in: &subscriptions)
    }
    
    deinit {
        for subscription in subscriptions {
            subscription.cancel()
        }
    }
}
