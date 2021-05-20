//
//  Chat.swift
//  Tango
//
//  Created by Глеб Бурштейн on 14.05.2021.
//

import Foundation

class Chat: Codable, Identifiable {
    var id: Int { return chatId }
    
    var chatId: Int
    var name: String
    var info: String?
    var avatar: String?
    
}
