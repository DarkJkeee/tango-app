//
//  TabbedPageView.swift
//  Tango
//
//  Created by Глеб Бурштейн on 01.11.2020.
//

import SwiftUI

struct TabbedPageView: View {
    var body: some View {
        NavigationView {
            TabBar()
        }
    }
}

struct TabBar: View {
    @Environment(\.colorScheme) var colorScheme
    
    init() {
        UITabBar.appearance().isTranslucent = false
    }
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                }
                .tag(0)
            ChatListView()
                .tabItem {
                    Image(systemName: "message")
                }
                .tag(1)
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                }
                .tag(2)
        }
        .accentColor(colorScheme == .dark ? .AccentColorLight : .AccentColorDark)
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
