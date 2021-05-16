//
//  ChatView.swift
//  Tango
//
//  Created by Глеб Бурштейн on 02.04.2021.
//

import SwiftUI

struct ChatListView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var profileVM: ProfileViewModel
    @StateObject var chatListVM = ChatListViewModel()
    
    @State var searchText = ""
    @State var showInvitations = false
    
    var body: some View {
        NavigationView {
            VStack {
                topbar
                content
            }
            .onAppear() {
                chatListVM.getChats()
            }
            .sheet(isPresented: $chatListVM.isShowingNewChatTab, content: {
                NewChat(chatListVM: chatListVM)
            })
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    private var topbar: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Messages")
                    .font(.custom("Dosis-Bold", size: 40))
                Spacer()

                Button(action: {
                    chatListVM.isShowingNewChatTab = true
                }, label: {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 30, height: 30)
                })
            }
            .padding([.trailing, .leading], 20)
            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "plus")
                            .resizable()
                            .foregroundColor(.lairDarkGray)
                            .frame(width: 25, height: 25)
                            .padding(20)
                    })
                    .background(Color.lairGray)
                    .clipShape(Circle())
                    
                    ForEach(1...7, id: \.self) {_ in
                        Button(action: {
                            
                        }, label: {
                            Image("tango")
                                .resizable()
                                .renderingMode(.original)
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                        })
                    }
                }
                .padding()
            }
            SearchBar(text: $searchText, placeholder: "Search")
        }
        .foregroundColor(colorScheme == .dark ? .AccentColorLight : .AccentColorDark)
        .background(colorScheme == .dark ? Color.backgroundColorDark : Color.backgroundColorLight)
        .cornerRadius(15)
    }
    
    private var content: some View {
        VStack {
            if !chatListVM.invitations.isEmpty {
                Button(action: {
                    showInvitations = true
                }, label: {
                    Text("You have \(chatListVM.invitations.count) new invitation(s)")
                })
            }
            ScrollView {
                PullToRefresh(coordinateSpaceName: "pullRefresh") {
                    chatListVM.getChats()
                }
                ForEach(chatListVM.chats) { chat in
                        NavigationLink(
                            destination:
                                ChatView(messages: [Message(id: 1, sender: .me, content: "Hello!!"),
                                                    Message(id: 2, sender: .other(named: "Vitaliy"), content: "Hi!"),
                                                    Message(id: 3, sender: .me, content: "вфыв!!"),
                                                    Message(id: 4, sender: .other(named: "Vitaliy"), content: "в!")]),
                            label: {
                                CellView(chat: chat)
                            })
                    }
            }
            .coordinateSpace(name: "pullRefresh")
        }
        .sheet(isPresented: $showInvitations, content: {
            ScrollView {
                ForEach(chatListVM.chats) { chat in
                    HStack {
                        CellView(chat: chat)
                        Button(action: {
                            
                        }, label: {
                            Text("Accept")
                        })
                    }
                    .padding()
                }
            }
            .background(colorScheme == .dark ? Color.backgroundColorDark: Color.backgroundColorLight)
            .foregroundColor(colorScheme == .dark ? .AccentColorLight: .AccentColorDark)
        })
    }
}


struct CellView: View {
    let chat: Chat
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 12) {
            Image("tango")
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 6) {
                Text(chat.name)
                    .lineLimit(1)
                    .font(.custom("Dosis-Bold", size: 20))
                Text(chat.info)
                    .lineLimit(2)
                    .font(.custom("Dosis-Regular", size: 15))
                    .font(.caption)
            }
            Spacer()
            Text("12/07/2021")
                .font(.custom("Dosis-Regular", size: 14))
        }
        .foregroundColor(colorScheme == .dark ? .AccentColorLight : .AccentColorDark)
        .padding()
    }
}


struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView()
            .preferredColorScheme(.dark)
    }
}
