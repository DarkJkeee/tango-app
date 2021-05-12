//
//  SessionViewModel.swift
//  Tango
//
//  Created by Глеб Бурштейн on 31.03.2021.
//

import Foundation
import Combine
import SwiftUI

class RegistrationViewModel: ObservableObject {
//    @AppStorage("jwt_token") private var token = ""
//    @AppStorage("user_id") private(set) var userId = -1
    
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordAgain: String = ""
    
    @Published var usernameError = ""
    @Published var passwordError = ""
    
    @Published var isFormValid = false
    @Published var isExist = false
    
    @Published var isLoading = false
    @Published var isValid = false
    
    private var cancellables = Set<AnyCancellable>()
    
    private let predicate = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&]).{6,}$")
    
    init() {
        isFormValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isFormValid, on: self)
            .store(in: &cancellables)
        
        isUsernameValidPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .map {
                if $0 == .tooShort {
                    return "Username is too short!"
                } else {
                    return ""
                }
            }
            .assign(to: \.usernameError, on: self)
            .store(in: &cancellables)
        
        isPasswordValidPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .map {
                switch $0 {
                case .empty:
                    return "Password cannot be empty!"
                case .notStrongEnough:
                    return "Password is weak!"
                case .repeatedPasswordWrong:
                    return "Passwords don't match!"
                case .valid:
                    return ""
                }
            }
            .assign(to: \.passwordError, on: self)
            .store(in: &cancellables)
    }
    
    func register() {
        isLoading = true
        Session.shared.register(email: email, username: username, password: password)
            .receive(on: RunLoop.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    switch error {
                        case .custom(let msg):
                            print(msg)
                        case .usernameExist:
                            self.isExist = true
                        default:
                            print("something went wrong")
                    }
                } else {
                    self.isValid = true
                }
                self.isLoading = false
            } receiveValue: { value in
                
            }
            .store(in: &cancellables)
//        username = ""
//        password = ""
//        passwordAgain = ""
//        email = ""
    }
    
    deinit {
        for subscription in cancellables {
            subscription.cancel()
        }
    }
}

extension RegistrationViewModel {
    
    private var isUsernameValidPublisher: AnyPublisher<UsernameStatus, Never> {
        $username
            .removeDuplicates()
            .map {
                self.isExist = false
                if ($0.count >= 3) {
                    return UsernameStatus.valid
                }
                else {
                    return UsernameStatus.tooShort
                }
            }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordEmptyPublisher: AnyPublisher<Bool, Never> {
        $password
            .removeDuplicates()
            .map { $0.isEmpty }
            .eraseToAnyPublisher()
    }
    
    private var arePasswordsMatches: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($password, $passwordAgain)
            .map { $0 == $1 }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordStrongPublisher: AnyPublisher<Bool, Never> {
        $password
            .removeDuplicates()
            .map {
                self.predicate.evaluate(with: $0)
            }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordValidPublisher: AnyPublisher<PasswordStatus, Never> {
        Publishers.CombineLatest3(isPasswordEmptyPublisher, arePasswordsMatches, isPasswordStrongPublisher)
            .map {
                if $0 {
                    return PasswordStatus.empty
                }
                if !$2 {
                    return PasswordStatus.notStrongEnough
                }
                if !$1 {
                    return PasswordStatus.repeatedPasswordWrong
                }
                return PasswordStatus.valid
            }
            .eraseToAnyPublisher()
    }
    
    private var isFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isUsernameValidPublisher, isPasswordValidPublisher)
            .map { $0 == .valid && $1 == .valid }
            .eraseToAnyPublisher()
    }
}

extension RegistrationViewModel {
    enum UsernameStatus {
        case tooShort
        case valid
    }
    
    enum PasswordStatus {
        case empty
        case notStrongEnough
        case repeatedPasswordWrong
        case valid
    }
}
