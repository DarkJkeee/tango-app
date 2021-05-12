//
//  ChatView.swift
//  Tango
//
//  Created by Глеб Бурштейн on 02.04.2021.
//

import SwiftUI

struct ChatListView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var searchText = ""
    @State var isShowing = false
    // TODO: VM
    
    var body: some View {
        NavigationView {
            VStack {
                topbar
                content
            }
            .sheet(isPresented: $isShowing, content: {
                VStack {
                    TextBar(text: $searchText, placeholder: "Chat name", imageName: "message", isSecureField: false)
                        .padding()
                    
                    Spacer()
                    AccentButton(title: "Create", height: 60) {
                        
                    }
                    .foregroundColor(colorScheme == .dark ? .AccentLight : .AccentDark)
                }
                .foregroundColor(colorScheme == .dark ? .AccentColorLight : .AccentColorDark)
                .background(colorScheme == .dark ? Color.backgroundColorDark : Color.backgroundColorLight)
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
                    isShowing.toggle()
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
            
            SearchBar(text: $searchText)
        }
        .foregroundColor(colorScheme == .dark ? .AccentColorLight : .AccentColorDark)
        .background(colorScheme == .dark ? Color.backgroundColorDark : Color.backgroundColorLight)
        .cornerRadius(15)
    }
    
    private var content: some View {
        ScrollView {
            ForEach(1..<14) { index in
                    NavigationLink(
                        destination:
                            ChatView(messages: [Message(id: 1, sender: .me, content: "Hello!!"),
                                                Message(id: 2, sender: .other(named: "Vitaliy"), content: "Hi!"),
                                                Message(id: 3, sender: .me, content: "вфыв!!"),
                                                Message(id: 4, sender: .other(named: "Vitaliy"), content: "в!")]),
                        label: {
                            CellView()
                        })
                }
            .onDelete(perform: { indexSet in
                
            })
        }
    }
}


struct CellView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 12) {
            Image("tango")
                .resizable()
                .frame(width: 55, height: 55)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Glebadsdasdasdasdasdasd")
                    .lineLimit(1)
                    .font(.custom("Dosis-Bold", size: 20))
                Text("Message...")
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
