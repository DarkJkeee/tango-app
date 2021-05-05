//
//  SessionAPI.swift
//  Tango
//
//  Created by Глеб Бурштейн on 02.05.2021.
//

import Foundation
import Combine

class SessionAPI {
    public static let shared = SessionAPI()
    private var subscriptions = Set<AnyCancellable>()
    private init() {}
    
    public func login(email: String, password: String) -> Future<String, SessionError> {
        return Future<String, SessionError> { promise in
            
        }
    }
    
    public func register() {
        
    }
}

public enum SessionError: Error {
    case invalidCredentials
    case custom(msg: String)
}
