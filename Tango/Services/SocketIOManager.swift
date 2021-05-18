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
    
    private func JSONStringify(value: MessageRes) -> String {
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
            messages.append(Message(sender: message.sender, content: message.content ?? ""))
        }
        
    }
    
    func stompClientDidDisconnect(client: StompClientLib!) {
        print("Socket is Disconnected")
        client.disconnect()
    }
    
    func stompClientDidConnect(client: StompClientLib!) {
        print("Connect")
        
        client.subscribe(destination: "/topic/public")
        
        let jsonstr = JSONStringify(value: MessageRes(type: "JOIN", content: nil, sender: username))
        
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
    
    public func sendMessage(message: Message) {
        
        let sentMessage = MessageRes(type: "CHAT", content: message.content, sender: username)
        socket.sendMessage(message: JSONStringify(value: sentMessage), toDestination: "/app/chat.sendMessage", withHeaders: nil, withReceipt: nil)
        
    }
    
}

struct UserBody: Encodable {
    var type: String
    var sender: String
}

struct MessageRes: Codable {
    var type: String
    var content: String?
    var sender: String
}

