//
//  ProfileViewModel.swift
//  Tango
//
//  Created by Глеб Бурштейн on 08.05.2021.
//

import UIKit
import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    @Published var mainUser = User(userId: -1, username: "Unknown", email: "", age: 0, userRoles: [], avatar: "")
//    @Published var currentUser = User(userId: -1, username: "Unknown", email: "", age: 0, userRoles: [], avatar: "")
    
    @Published var dismiss = false
    @Published var isLoading = false
    @Published var error = Failed.none
    
    private var subscriptions = Set<AnyCancellable>()
    
    private func setValuesToUser(user: User) {
        self.mainUser.userId = user.userId
        self.mainUser.username = user.username
        self.mainUser.email = user.email
        self.mainUser.age = user.age
        self.mainUser.userRoles = user.userRoles
        self.mainUser.avatar = user.avatar
    }
    
    func updateProfileView() {
        error = .none
        
    }
    
    init(id: Int) {
        ProfileAPI.shared.loadProfile(with: id)
            .receive(on: RunLoop.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    switch error {
                    case .custom(let message):
                        print(message)
                    default: print("Some error")
                    }
                }
            } receiveValue: { user in
                self.setValuesToUser(user: user)
            }
            .store(in: &subscriptions)
    }
    
    func editProfile(field: String, value: String) {
        isLoading = true
        ProfileAPI.shared.changeProfile(with: mainUser.userId, field: field, value: value)
            .receive(on: RunLoop.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    switch error {
                    case .exist:
                        self.error = .exist
                    case .custom(let message):
                        print(message)
                    }
                } else {
                    self.dismiss.toggle()
                    self.error = .none
                }
                self.isLoading = false
            } receiveValue: { newUser in
                self.setValuesToUser(user: newUser)
            }
            .store(in: &subscriptions)
    }
    
//    func loadProfileWith(id: Int) {
//        ProfileAPI.shared.loadProfile(with: id)
//            .receive(on: RunLoop.main)
//            .sink { completion in
//                if case let .failure(error) = completion {
//                    switch error {
//                    case .custom(let message):
//                        print(message)
//                    default: print("Some error")
//                    }
//                }
//            } receiveValue: { user in
//                self.currentUser.userId = user.userId
//                self.currentUser.username = user.username
//                self.currentUser.email = user.email
//                self.currentUser.age = user.age
//                self.currentUser.userRoles = user.userRoles
//            }
//            .store(in: &subscriptions)
//    }
    
    func changeAvatar(avatar: UIImage) {
        let imageData = avatar.jpegData(compressionQuality: 1)
        let imageBase64String = imageData?.base64EncodedString()
        if let base64img = imageBase64String {
            editProfile(field: "avatar", value: base64img)
        }
    }
    
    deinit {
        for subscription in subscriptions {
            subscription.cancel()
        }
    }
}


enum Failed {
    case none
    case exist
}
