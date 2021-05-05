//
//  LoginViewModel.swift
//  Tango
//
//  Created by Глеб Бурштейн on 30.04.2021.
//

import Foundation
import Combine

class LoginViewModel : ObservableObject {
    @Published var state = LoginViewModel.State.idle
    @Published var isLogged = false
    @Published var isFailed = false
    
    @Published var email = ""
    @Published var password = ""
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
//        $state
//            .receive(on: RunLoop.main)
//            .map {
//                $0 == .loggedIn
//            }
//            .assign(to: \.isLogged, on: self)
//            .store(in: &subscriptions)
//        $state
//            .receive(on: RunLoop.main)
//            .map {
//                $0 == .failed
//            }
//            .assign(to: \.isFailed, on: self)
//            .store(in: &subscriptions)
    }
    
    func login() {
//        state = .logging
//        SessionAPI.shared.login(email: email, password: password)
    }
    
    deinit {
        for subscription in subscriptions {
            subscription.cancel()
        }
    }
}

extension LoginViewModel {
    enum State {
        case idle
        case logging
        case loggedIn
        case failed
    }
}
