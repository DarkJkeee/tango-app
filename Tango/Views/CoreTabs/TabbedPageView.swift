//
//  TabbedPageView.swift
//  Tango
//
//  Created by Глеб Бурштейн on 01.11.2020.
//

import SwiftUI

struct TabbedPageView: View {
    @State var showSplash = true
    
    var body: some View {
            TabBar()
    }
}

struct TabBar: View {
    
    init() {
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = UIColor(Color.BackgroundColor)
    }
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                }
                .tag(0)
            Text("Soon...")
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
                .tag(1)
            Text("Plus")
                .tabItem {
                    Image(systemName: "plus")
                }
                .tag(2)
            ChatListView()
                .tabItem {
                    Image(systemName: "message")
                }
                .tag(3)
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                }
                .tag(4)
        }
        .accentColor(Color.AccentColor)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct TabbedPageView_Previews: PreviewProvider {
    static var previews: some View {
        TabbedPageView()
            .preferredColorScheme(.dark)
    }
}
