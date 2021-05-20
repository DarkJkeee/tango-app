//
//  ChatManager.swift
//  Tango
//
//  Created by Глеб Бурштейн on 16.05.2021.
//

import Foundation
import StompClientLib
import Combine

class SocketIOManager: ObservableObject, StompClientLibDelegate {
    private var subscription: AnyCancellable?
    private var username: String = "Unknown"
    private var decoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
    
    @Published var messages = [MessageDTO]()
    
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
        
        let message = try? decoder.decode(MessageDTO.self, from: stringBody?.data(using: .utf8) ?? Data())
        
        if message != nil {
            messages.append(message!)
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
    
    public func connect(username: String) {
        self.username = username
        
        let url = URL(string: "wss://tango-server-db-eu.herokuapp.com/ws/websocket")!
        let request = NSURLRequest(url: url)
        
        socket.openSocketWithURLRequest(request: request, delegate: self)
        getHistory(id: 1)
    }
    
    public func sendMessage(message: Message, user: User) {
        
        let sentMessage = MessageBody(messageType: "CHAT", message: message.content, chatUserId: 2, chatId: 1, posted: "2021-05-20")
        socket.sendMessage(message: JSONStringify(value: sentMessage), toDestination: "/app/chat.sendMessage", withHeaders: nil, withReceipt: nil)
        
    }
    
    public func getHistory(id: Int) {
        subscription = ChatAPI.shared.getHistory(id: id)
            .receive(on: RunLoop.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    switch error {
                    case .custom(let msg):
                        print(msg)
                    }
                }
            } receiveValue: { history in
                self.messages = history
            }
    }
    
}

struct MessageRes: Codable {
    var body: MessageDTO
}

struct MessageDTO: Codable, Identifiable {
    var id: Int { return messageId }
    
    var messageId: Int
    var messageType: String
    var message: String?
    
    var posted: String
    var username: String
    var avatar: String
    
}

struct HistoryResponse: Decodable {
    var result: [MessageDTO]
    var pagination: Pagination
}

struct MessageBody: Codable {
    var messageType: String
    var message: String
    var chatUserId: Int
    var chatId: Int
    var posted: String
}
