//
//  ChatManager.swift
//  Tango
//
//  Created by Глеб Бурштейн on 16.05.2021.
//

import Foundation
import StompClientLib

class SocketIOManager: ObservableObject, StompClientLibDelegate {
    private var username: String = "Unknown"
    
    private func JSONStringify<T: Codable>(value: T) -> String {
        var jsonString = ""
        do {
            let jsonData = try JSONEncoder().encode(value)
            jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonString)
            
        } catch { print(error) }
        
        return jsonString
    }
    
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        
        let message = try? JSONDecoder().decode(MessageRes.self, from: stringBody?.data(using: .utf8) ?? Data())
        if let message = message {
            if message.body.message != "" {
                messages.append(Message(sender: message.body.username, content: message.body.message))
            }
        }
        
    }
    
    func stompClientDidDisconnect(client: StompClientLib!) {
        print("Socket is Disconnected")
        client.disconnect()
    }
    
    func stompClientDidConnect(client: StompClientLib!) {
        print("Connect")
        
        client.subscribe(destination: "/topic/public")
        
        let jsonstr = "{\"type\":\"JOIN\",\"sender\":\"\(username)\"}"
        print(jsonstr)
        client.sendMessage(message: jsonstr, toDestination: "/app/chat.addUser", withHeaders: nil, withReceipt: nil)
        
    }
    
    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
        print("Receipt : \(receiptId)")
    }
    
    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        print("Error Send : \(String(describing: message))")
    }
    
    func serverDidSendPing() {
        print("Server ping")
    }
    
    private var socket = StompClientLib()
    
    @Published var messages = [Message]()
    
    public func connect(username: String) {
        self.username = username
        
        let url = URL(string: "wss://tango-server-db-eu.herokuapp.com/ws/websocket")!
        let request = NSURLRequest(url: url)
        
        socket.openSocketWithURLRequest(request: request, delegate: self)
    }
    
    public func sendMessage(message: Message, user: User) {
        
        let sentMessage = MessageBody(messageType: "CHAT", message: message.content, chatUserId: 1, chatId: 1, posted: "2021-05-20T09:28:40.648Z")
        socket.sendMessage(message: JSONStringify(value: sentMessage), toDestination: "/app/chat.sendMessage", withHeaders: nil, withReceipt: nil)
        
    }
    
}

struct MessageRes: Codable {
    var body: Body
}

struct Body: Codable {
    var messageType: String
    var message: String
    
    var posted: String
    var username: String
    var avatar: String
    
}

struct MessageBody: Codable {
    var messageType: String
    var message: String
    var chatUserId: Int
    var chatId: Int
    var posted: String
}
