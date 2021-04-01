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
        if showSplash {
            ZStack {
                Color.white.edgesIgnoringSafeArea(.all)
                Image("tango")
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.showSplash = false
                }
            }
            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5)))
            .zIndex(1)
        } else {
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
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.fill")
                    }
                    .tag(2)
            }
            .navigationBarTitle("Title")
            .toolbar(content: {
                Button(action: {
                    
                }, label: {
                    Image(systemName: "arrow.up.and.person.rectangle.portrait")
                })
            })
            .accentColor(Color.AccentColor)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct TabbedPageView_Previews: PreviewProvider {
    static var previews: some View {
        TabbedPageView()
    }
}
