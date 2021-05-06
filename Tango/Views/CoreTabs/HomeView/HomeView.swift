//
//  HomeView.swift
//  Tango
//
//  Created by Глеб Бурштейн on 01.11.2020.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var homeVM = MoviesListViewModel()
    
    var body: some View {
        VStack {
            switch homeVM.state {
            case .idle:
                (colorScheme == .dark ? Color.backgroundColorDark : Color.backgroundColorLight)
                    .onAppear() {
                        homeVM.fetchData()
                    }
            case .loading:
                ZStack {
                    colorScheme == .dark ? Color.backgroundColorDark : Color.backgroundColorLight
                    ProgressView("Loading...")
                }
            case .error(let error):
                ZStack {
                    colorScheme == .dark ? Color.backgroundColorDark : Color.backgroundColorLight
                    VStack {
                        AlertView(error: error, retryAction: { homeVM.fetchData() })
                    }
                }
            case .loaded(let movies):
                content(movies: movies)
            }
        }
        .navigationBarHidden(true)
        .background(colorScheme == .dark ? Color.backgroundColorDark : Color.backgroundColorLight)
        .edgesIgnoringSafeArea(.all)
    }
    
    private func content(movies: [Int: [Movie]]) -> some View {
        return VStack {
            topbar
            SearchBar(text: $homeVM.searchText)
                .cornerRadius(15)
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
                        Divider()
                        MovieSearchCard(movie: movie)
                    }
                }
                .animation(Animation.easeInOut.speed(1))
                .padding()
            case .error(let error):
                ZStack {
                    colorScheme == .dark ? Color.backgroundColorDark : Color.backgroundColorLight
                    Text("There are some error with query: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private var topbar: some View {
        HStack {
            Text("Home")
                .font(.custom("Dosis-Bold", size: 40))
                .foregroundColor(colorScheme == .dark ? .AccentColorLight : .AccentColorDark)
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
