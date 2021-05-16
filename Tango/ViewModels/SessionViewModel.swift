//
//  LoginViewModel.swift
//  Tango
//
//  Created by Глеб Бурштейн on 30.04.2021.
//

import Foundation
import LocalAuthentication
import Combine

class SessionViewModel: ObservableObject {
    
    @Published var state = State.idle
    @Published var isLogged = false
    @Published var errorMsg = ""
    
    @Published var email = ""
    @Published var password = ""
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        $state
            .receive(on: RunLoop.main)
            .map {
                switch $0 {
                    case .loggedIn: return true
                    default: return false
                }
            }
            .assign(to: \.isLogged, on: self)
            .store(in: &subscriptions)
    }
    
    func login() {
        state = .logging
        Session.shared.login(email: email, password: password)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    self.state = .idle
                    switch error {
                    case SessionError.invalidCredentials:
                        self.errorMsg = "Invalid username or password!"
                    case SessionError.custom(let msg):
                        self.errorMsg = msg
                    default:
                        self.errorMsg = "Something went wrong"
                    }
                } else {
                    self.state = .loggedIn
                }
            }, receiveValue: { _ in })
            .store(in: &subscriptions)
        email = ""
        password = ""
    }
    
    func logout() {
        state = .idle
        errorMsg = ""
        Session.shared.logout()
    }
    
    func authenticateWithoutPass() {
        let context = LAContext()
        var error: NSError?
        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "We need to authenticate you."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                DispatchQueue.main.async {
                    if success {
                        self.state = .loggedIn
                    }
                }
            }
        } else {
            return
        }
    }
    
    deinit {
        for subscription in subscriptions {
            subscription.cancel()
        }
    }
}

extension SessionViewModel {
    enum State {
        case idle
        case logging
        case loggedIn
    }
}
