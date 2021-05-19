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
    @Published var mainUser = User(userId: -1, username: "Unknown", email: "", age: 0, userRoles: [], avatar: "", favorite: [])
//    @Published var currentUser = User(userId: -1, username: "Unknown", email: "", age: 0, userRoles: [], avatar: "")
    
    @Published var logout = false
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
        self.mainUser.favorite = user.favorite
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
                    case .custom(_, let code):
                        if code == 401 {
                            Session.shared.logout()
                        }
                    default: print("Some error")
                    }
                }
            } receiveValue: { user in
                self.setValuesToUser(user: user)
            }
            .store(in: &subscriptions)
    }
    
    func addFilmToFavourite(id: Int) {
        ProfileAPI.shared.favouriteFilm(id: id, method: "POST")
            .receive(on: RunLoop.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    switch error {
                    case .custom(let msg, _):
                        print(msg)
                    default: print(error.localizedDescription)
                    }
                }
            } receiveValue: { user in
                self.setValuesToUser(user: user)
            }
            .store(in: &subscriptions)
    }
    
    func removeFilmFromFavourite(id: Int) {
        ProfileAPI.shared.favouriteFilm(id: id, method: "DELETE")
            .receive(on: RunLoop.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    switch error {
                    case .custom(let msg, _):
                        print(msg)
                    default: print(error.localizedDescription)
                    }
                }
            } receiveValue: { user in
                self.setValuesToUser(user: user)
            }
            .store(in: &subscriptions)
    }
    
    func editProfile(field: String, value: String) {
        if !value.isEmpty {
            isLoading = true
            ProfileAPI.shared.changeProfile(with: mainUser.userId, field: field, value: value)
                .receive(on: RunLoop.main)
                .sink { completion in
                    if case let .failure(error) = completion {
                        switch error {
                        case .exist:
                            self.error = .exist
                        case .custom(let msg, _):
                            print(msg)
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
    }
    
    func changeAvatar(avatar: UIImage) {
        let imageData = avatar.jpegData(compressionQuality: 1)
        let imageBase64String = imageData?.base64EncodedString()
        if let base64img = imageBase64String {
            editProfile(field: "avatar", value: base64img)
        }
    }
    
    func deleteUser() {
        ProfileAPI.shared.deleteUser(id: mainUser.userId)
            .receive(on: RunLoop.main)
            .sink { completion in
                if case .failure(_) = completion {
                    self.error = .delete
                }
            } receiveValue: { value in
                if value == "OK" {
                    self.logout = true
                }
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
    
    deinit {
        for subscription in subscriptions {
            subscription.cancel()
        }
    }
}


enum Failed {
    case none
    case exist
    case delete
}
