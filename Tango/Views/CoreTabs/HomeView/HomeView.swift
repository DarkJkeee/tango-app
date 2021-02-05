//
//  HomeView.swift
//  Tango
//
//  Created by Глеб Бурштейн on 01.11.2020.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var homeVM = MoviesViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(0..<5) { _ in
                    CardListView(movies: homeVM.movies, genre: "genre")
                }
            }
            .navigationBarTitle("Home")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        TabbedPageView()
    }
}

