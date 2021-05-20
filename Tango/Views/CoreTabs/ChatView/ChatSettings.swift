//
//  NewChat.swift
//  Tango
//
//  Created by Глеб Бурштейн on 14.05.2021.
//

import SwiftUI

struct ChatSettings: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var profileVM: ProfileViewModel
    @ObservedObject var chatListVM: ChatListViewModel
    
    @State var isImagePicker = false
    
    var body: some View {
        VStack {
            ScrollView {
                Section(header: Text("Name").font(.custom("Dosis-Bold", size: 20))) {
                    TextBar(text: $chatListVM.chatName, placeholder: "Chat name", imageName: "message", isSecureField: false)
                    TextBar(text: $chatListVM.chatInfo, placeholder: "Description", imageName: "pencil", isSecureField: false)
                }
                Section(header: Text("Image").font(.custom("Dosis-Bold", size: 20))) {
                    HStack {
                        AccentButton(title: "Choose a photo", width: 200, height: 60) {
                            isImagePicker = true
                        }
                        
                        Spacer()
                        
                        if let image = chatListVM.chosenImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                        } else {
                            Image("tango")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                        }
                    }
                    .padding()
                    .foregroundColor(colorScheme == .dark ? .AccentLight : .AccentDark)
                }
                Section(header: Text("Members").font(.custom("Dosis-Bold", size: 20))) {
                    SearchBar(text: $chatListVM.searchingText, placeholder: "Search user")
                    switch chatListVM.searchState {
                        case .idle: EmptyView()
                        case .loading: ProgressView()
                        case .loaded(let users):
                        ScrollView {
                            LazyVStack {
                                ForEach(users) { user in
                                    Button(action: {
                                        let id = user.userId
                                        if chatListVM.chosenUsers.contains(id) {
                                            chatListVM.chosenUsers.remove(at: chatListVM.chosenUsers.firstIndex(of: id) ?? 0)
                                        } else {
                                            chatListVM.chosenUsers.append(id)
                                        }
                                    }, label: {
                                        HStack {
                                            UserCard(user: user)
                                            Image(systemName: chatListVM.chosenUsers.contains(user.userId) ? "checkmark.circle.fill" : "checkmark.circle")
                                                .resizable()
                                                .frame(width: 30, height: 30)
                                            
                                        }
                                        .padding()
                                    })
                                }
                            }
                        }
                    }
                }
            }
            Spacer()
            AccentButton(title: "Create", height: 60) {
                chatListVM.createChat()
            }
            .foregroundColor(colorScheme == .dark ? .AccentLight : .AccentDark)
        }
        .onAppear() {
            chatListVM.chosenUsers.removeAll()
        }
        .sheet(isPresented: $isImagePicker, content: {
            ImagePicker(sourceType: .photoLibrary) { image in
                chatListVM.chosenImage = image
            }
        })
        .foregroundColor(colorScheme == .dark ? .AccentColorLight : .AccentColorDark)
        .background(colorScheme == .dark ? Color.backgroundColorDark : Color.backgroundColorLight)
    }
}
