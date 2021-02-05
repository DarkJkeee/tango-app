//
//  TabbedPageView.swift
//  Tango
//
//  Created by Глеб Бурштейн on 01.11.2020.
//

import SwiftUI

struct TabbedPageView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                }
                .tag(0)
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
                .tag(1)
            Text("Hello")
                .tabItem {
                    Image(systemName: "play.fill")
                }
                .tag(2)
            Text("Hello, world")
                .tabItem {
                    Image(systemName: "bell.fill")
                }
                .tag(3)
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                }
                .tag(4)
        }
        .accentColor(colorScheme == .light ? Color.darkGray : Color.orange)
    }
}

struct TabbedPageView_Previews: PreviewProvider {
    static var previews: some View {
        TabbedPageView()
    }
}
