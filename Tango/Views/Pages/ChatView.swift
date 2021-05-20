//
//  ChatView.swift
//  Tango
//
//  Created by Глеб Бурштейн on 03.04.2021.
//

import SwiftUI
import Combine

struct ChatView: View {
    
    @EnvironmentObject var profileVM: ProfileViewModel
    @ObservedObject var chatListVM: ChatListViewModel
    @StateObject var socketManager = SocketIOManager()
    @State var isShowing = false
    @State var typingMessage = ""
    @State private var keyboardHeight: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
//                HStack {
//                    Spacer()
//                    Button(action: {
//                        isShowing = true
//                    }) {
//                        Image(systemName: "gear")
//                    }
//                }
                ScrollView {
                    ForEach(socketManager.messages) { message in
                        MessageView(message: message)
                            .padding(.horizontal, 8)
                            .padding(EdgeInsets(
                                        top: 0,
                                        leading: message.username == profileVM.mainUser.username ? geometry.size.width * 0.5 : 0 ,
                                        bottom: 0,
                                        trailing: message.username == profileVM.mainUser.username ? 0 : geometry.size.width * 0.5))
                        
                    }
                }
                
                HStack {
                    TextField("Message...", text: $typingMessage)
                       .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        socketManager.sendMessage(message: Message(sender: profileVM.mainUser.username, content: typingMessage), user: profileVM.mainUser)
                        typingMessage = ""
                    }) {
                        Image(systemName: "arrow.up.right.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                 }
                .padding()
            }
        }
        .onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
        .sheet(isPresented: $isShowing) {
            ChatSettings(chatListVM: chatListVM)
        }
        .onAppear() {
            socketManager.connect(username: profileVM.mainUser.username)
        }
    }
}
