//
//  ChatView.swift
//  Tango
//
//  Created by Глеб Бурштейн on 03.04.2021.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var profileVM: ProfileViewModel
    @StateObject var socketManager = SocketIOManager()
    @State var typingMessage = ""
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView {
                    ForEach(socketManager.messages) { message in
                        MessageView(message: message)
                            .padding(.horizontal, 8)
                            .padding(EdgeInsets(
                                        top: 0,
                                        leading: message.sender == profileVM.mainUser.username ? geometry.size.width * 0.5 : 0 ,
                                        bottom: 0,
                                        trailing: message.sender == profileVM.mainUser.username ? 0 : geometry.size.width * 0.5))
                        
                    }
                }
                
                HStack {
                    TextField("Message...", text: $typingMessage)
                       .textFieldStyle(RoundedBorderTextFieldStyle())
                       .frame(minHeight: CGFloat(30))
                    Button(action: {
                        socketManager.sendMessage(message: Message(sender: profileVM.mainUser.username, content: typingMessage))
                        typingMessage = ""
                    }) {
                        Image(systemName: "arrow.up.right.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                 }.frame(minHeight: CGFloat(50)).padding()
            }
        }
        .onAppear() {
            socketManager.connect(username: profileVM.mainUser.username)
        }
    }
}
