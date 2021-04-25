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
    
    @State var isShowing = false
    var body: some View {
        VStack {
            switch homeVM.state {
            case .idle:
                Color("Background")
                    .onAppear() {
                        homeVM.fetchData()
                    }
                    .eraseToAnyView()
            case .loading:
                ZStack {
                    Color("Background")
                    ProgressView("Loading...")
                }
                .eraseToAnyView()
            case .error(let error):
                ZStack {
                    Color("Background")
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
                topbar
                //                TextField("Search ...", text: $text, onCommit: {
                //
                //                })
                ScrollView {
                    ForEach(homeVM.genres) { genre in
                        Divider()
                        CardListView(movies: movies[genre.id] ?? [], genre: genre.name)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .background(Color("Background"))
        .edgesIgnoringSafeArea(.all)
    }
    
    private var topbar: some View {
        HStack {
            Text("Home")
                .font(.custom("Dosis-Bold", size: 40))
                .foregroundColor(Color("AccentColor"))
            Spacer()
            // TODO: topbar buttons...
        }
        .padding(.top, UIScreen.main.bounds.height * 0.05)
        .padding(.leading, 20)
        .padding(.bottom, 1)
    }
    
}

struct CardListView: View {
    let movies: [Movie]
    let genre: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(genre)
                .font(.custom("Dosis-Bold", size: 26))
                .foregroundColor(Color("AccentColor"))
                .padding(.leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top) {
                    ForEach(movies) { movie in
                        NavigationLink(destination: MoviePage(movie: movie),
                                       label: {
                                        MovieCardView(movie: movie)
                                            .frame(width: 300)
                                            .padding(.trailing, 30)
                                       })
                    }
                }
            }
            .padding()
        }
    }
}

struct MovieCardView: View {
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Poster(poster: movie.posterPath, size: .medium) {
                ProgressView()
            }
            .aspectRatio(contentMode: .fill)
            .frame(width: 300, height: 170)
            .clipped()
            .shadow(color: .white, radius: 2, x: -3, y: -3)
            .shadow(color: .lairShadowGray, radius: 2, x: 3, y: 3)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(LinearGradient.lairDiagonalDarkBorder, lineWidth: 1)
            )
            .background(Color.lairBackgroundGray)
            .cornerRadius(10)
            VStack(alignment: .leading, spacing: 5) {
                Text(movie.title)
                    .foregroundColor(Color("AccentColor"))
                    .font(.custom("Dosis-Bold", size: 20))
                Text(movie.overview)
                    .font(.custom("Dosis-Regular", size: 15))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .frame(height: 40)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .preferredColorScheme(.dark)
    }
}
