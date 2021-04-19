//
//  ChatView.swift
//  Tango
//
//  Created by Глеб Бурштейн on 02.04.2021.
//

import SwiftUI

struct ChatListView: View {
    @State var searchText = ""
    // TODO: VM
    
    var body: some View {
        VStack {
            topbar
            content
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    private var topbar: some View {
        VStack {
            HStack {
                Text("Messages")
                    .font(.custom("Dosis-Bold", size: 40))
                    .foregroundColor(Color("Accent"))
                Spacer()
                
                Button(action: {
                    
                }, label: {
                    Image(systemName: "person.fill")
                        .resizable()
                        .foregroundColor(Color("Accent"))
                        .frame(width: 30, height: 30)
                })
            }
            .padding([.trailing, .leading], 20)
            .padding(.top, 35)
            .padding(.bottom, 1)
            
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
            
            HStack(spacing: 15) {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .foregroundColor(Color("Accent").opacity(0.3))
                
                TextField("Search", text: $searchText)
            }
            .padding()
            .cornerRadius(8)
        }
        .background(Color("Background"))
        .cornerRadius(15)
    }
    
    private var content: some View {
        List {
            ForEach(1..<14) { index in
                    NavigationLink(
                        destination: ChatView(),
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
                    .foregroundColor(Color("Accent"))
                Text("Message...")
                    .lineLimit(2)
                    .font(.custom("Dosis-Regular", size: 15))
                    .foregroundColor(Color("Accent"))
                    .font(.caption)
            }
            Spacer()
            Text("12/07/2021")
                .font(.custom("Dosis-Regular", size: 14))
                .foregroundColor(Color("Accent"))
        }
        .padding()
    }
}


struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView()
            .preferredColorScheme(.dark)
    }
}
