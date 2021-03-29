//
//  HomeView.swift
//  Tango
//
//  Created by Глеб Бурштейн on 01.11.2020.
//

import SwiftUI
import URLImage

struct HomeView: View {
    @ObservedObject var homeVM = MoviesListViewModel()
    
    var body: some View {
        NavigationView {
            content
            .navigationBarTitle("Home")
            .toolbar(content: {
                Button(action: {
                    
                }, label: {
                    Image(systemName: "arrow.up.and.person.rectangle.portrait")
                })
            })
        }
        .onAppear() {
            homeVM.getGenres()
        }
    }
    
    private var content: some View {
        VStack {
            ScrollView {
                ForEach(homeVM.genres) { genre in
                    CardListView(movies: homeVM.movies[genre.id] ?? [], genre: genre.name)
                        .onAppear() {
                            homeVM.getMovies(genre: genre.id)
                        }
                }
            }
        }
    }
}

struct CardListView: View {
    let movies: [Movie]
    let genre: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(genre)
                .font(.custom("Dosis-Bold", size: 26))
                .padding(.leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top) {
                    ForEach(movies) { movie in
                        NavigationLink(destination: MoviePage(movie: movie),
                                       label: {
                                        MovieCardView(movie: movie)
                                            .frame(width: 300)
                                            .padding(.trailing, 30)
                                       }).accentColor(.primary)
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
            URLImage(url: URL(string: "https://image.tmdb.org/t/p/w500" + (movie.poster_path ?? "/tnAuB8q5vv7Ax9UAEje5Xi4BXik.jpg"))!) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 300, height: 170)
                    .clipped()
                    .cornerRadius(10)
                    .shadow(color: .white, radius: 2, x: -3, y: -3)
                    .shadow(color: .lairShadowGray, radius: 2, x: 3, y: 3)
                    .overlay(
                      RoundedRectangle(cornerRadius: 10)
                        .stroke(LinearGradient.lairDiagonalDarkBorder, lineWidth: 1)
                    )
                    .background(Color.lairBackgroundGray)
                    .cornerRadius(10)
            }
            VStack(alignment: .leading, spacing: 5) {
                Text(movie.title)
                    .foregroundColor(.primary)
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
        TabbedPageView()
    }
}
