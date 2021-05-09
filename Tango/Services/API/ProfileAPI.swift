//
//  ProfileAPI.swift
//  Tango
//
//  Created by Глеб Бурштейн on 08.05.2021.
//

import Foundation
import Combine

class ProfileAPI {
    public static let shared = ProfileAPI()
    private init() {}
    private var subscriptions = Set<AnyCancellable>()
    
    
    
    
    deinit {
        for sub in subscriptions {
            sub.cancel()
        }
    }
}
