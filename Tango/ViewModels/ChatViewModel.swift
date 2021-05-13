//
//  ChatViewModel.swift
//  Tango
//
//  Created by Глеб Бурштейн on 13.05.2021.
//

import Foundation
import SocketIO

class ChatViewModel: ObservableObject {
    
    
    @Published var messages = [Message]()
    
    
}
