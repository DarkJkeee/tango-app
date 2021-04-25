//
//  HomeView.swift
//  Tango
//
//  Created by Глеб Бурштейн on 01.11.2020.
//

import SwiftUI

struct HomeView: View {
    @State var text = ""
    @ObservedObject var homeVM = MoviesListViewModel()
    
    var body: some View {
        VStack {
            switch homeVM.state {
            case .idle:
                Color.BackgroundColor
                    .onAppear() {
                        homeVM.fetchData()
                    }
            case .loading:
                ZStack {
                    Color.BackgroundColor
                    ProgressView("Loading...")
                }
            case .error(let error):
                ZStack {
                    Color.BackgroundColor
                    VStack {
                        AlertView(error: error)
                        Button(action: {
                            homeVM.fetchData()
                        }, label: {
                            Text("Retry")
                        })
                        .padding()
                    }
                }
            case .loaded(let movies):
                content(movies: movies)
            }
        }
        .navigationBarHidden(true)
        .background(Color.BackgroundColor)
        .edgesIgnoringSafeArea(.all)
    }
    
    private func content(movies: [Int: [Movie]]) -> some View {
        return VStack {
            topbar
            searchField
            switch homeVM.searchState {
            case .idle:
                ScrollView {
                    ForEach(homeVM.genres) { genre in
                        if movies[genre.id] != nil {
                            Divider()
                            CardListView(movies: movies[genre.id] ?? [], genre: genre.name)
                        }
                    }
                }
                .animation(Animation.easeInOut.speed(1))
            case .loaded(let movies):
                ScrollView {
                    ForEach(movies) { movie in
                        MovieSearchCard(movie: movie)
                    }
                }
                .animation(Animation.easeInOut.speed(1))
                .padding()
            case .error(_):
                ZStack {
                    Color.BackgroundColor
                    Text("There are no appropriate films!")
                }
            }
        }
    }
    
    private var searchField: some View {
        TextField("Search...", text: $homeVM.searchText)
            .padding(7)
            .padding(.horizontal, 25)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal, 10)
    }
    
    private var topbar: some View {
        HStack {
            Text("Home")
                .font(.custom("Dosis-Bold", size: 40))
                .foregroundColor(Color.AccentColor)
            Spacer()
            // TODO: topbar buttons...
        }
        .padding(.top, UIScreen.main.bounds.height * 0.05)
        .padding(.leading, 20)
        .padding(.bottom, 1)
    }
    
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .preferredColorScheme(.dark)
    }
}
