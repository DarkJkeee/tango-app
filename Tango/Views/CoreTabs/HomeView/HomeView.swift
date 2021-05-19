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
            .background(colorScheme == .dark ? Color.backgroundColorDark : Color.backgroundColorLight)
            .edgesIgnoringSafeArea(.all)
            .navigationBarHidden(true)
        
    }
    
    private func content(movies: [MovieDTO]) -> some View {
        return VStack {
            topbar
            SearchBar(text: $homeVM.searchText, placeholder: "Search")
                .cornerRadius(15)
            switch homeVM.searchState {
            case .idle:
                ScrollView {
                    LazyVStack {
                        ForEach(homeVM.genres) { genre in
//                            if movies[genre.id] != nil {
//                                Divider()
//                                CardListView(movies: movies[genre.id] ?? [], genre: genre.genreName)
//                            }
                            Divider()
                            CardListView(movies: movies, genre: genre.genreName)
                        }
                    }
                }
                .animation(Animation.easeInOut.speed(1))
            case .loaded(let movies):
                ScrollView {
                    LazyVStack {
                        ForEach(movies) { movie in
                            Divider()
                            NavigationLink(destination: MoviePage(movie: movie.film)) {
                                MovieSearchCard(movie: movie.film)
                            }
                        }
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
            Spacer()
            // TODO: topbar buttons...
        }
        .foregroundColor(colorScheme == .dark ? .AccentColorLight : .AccentColorDark)
        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
        .padding(.leading, 20)
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .preferredColorScheme(.dark)
    }
}
