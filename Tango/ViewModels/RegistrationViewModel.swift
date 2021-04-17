//
//  SessionViewModel.swift
//  Tango
//
//  Created by Глеб Бурштейн on 31.03.2021.
//

import Foundation
import Combine

class RegistrationViewModel : ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordAgain: String = ""
    
    @Published var inlineError = ""
    
    @Published var isValid = false
    
    private var cancellables = Set<AnyCancellable>()
    
    private let predicate = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&]).{6,}$")
    
    init() {
        isFormValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: self)
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
            .assign(to: \.inlineError, on: self)
            .store(in: &cancellables)
    }
    
    
}

extension RegistrationViewModel {
    
    private var isUsernameValidPublisher: AnyPublisher<Bool, Never> {
        $username
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { $0.count >= 3 }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordEmptyPublisher: AnyPublisher<Bool, Never> {
        $password
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { $0.isEmpty }
            .eraseToAnyPublisher()
    }
    
    private var arePasswordsMatches: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($password, $passwordAgain)
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .map { $0 == $1 }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordStrongPublisher: AnyPublisher<Bool, Never> {
        $password
            .debounce(for: 0.2, scheduler: RunLoop.main)
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
            .map { $0 && $1 == .valid }
            .eraseToAnyPublisher()
    }
}

extension RegistrationViewModel {
    enum PasswordStatus {
        case empty
        case notStrongEnough
        case repeatedPasswordWrong
        case valid
    }
}
