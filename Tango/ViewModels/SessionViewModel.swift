//
//  SessionViewModel.swift
//  Tango
//
//  Created by Глеб Бурштейн on 31.03.2021.
//

import Foundation
import Combine

class SessionViewModel : ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordAgain: String = ""
    
    @Published var isValid = true
    
    
    
}
