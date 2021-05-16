//
//  ChatManager.swift
//  Tango
//
//  Created by Глеб Бурштейн on 16.05.2021.
//

import Foundation
import SocketIO

class SocketIOManager {
    static let manager = SocketManager(socketURL: URL(string: "https://yoururl.com:443")!, config: [.log(true), .compress])
    static let socket = manager.defaultSocket
    
    class func connectSocket() {
        self.manager.config = SocketIOClientConfiguration(arrayLiteral: .connectParams(["token": ""]))
        socket.connect()
//        var a = SocketIOClient(manager: manager, nsp: "")
        
    }
    
    
    class func disconnectSocket() {
        socket.disconnect()
    }
}
