//
//  HomeView.swift
//  Tango
//
//  Created by Глеб Бурштейн on 01.11.2020.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var homeVM: MoviesViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                ForEach(0..<5) { _ in
                    CardListView(movies: homeVM.movies, title: "genre")
                }
            }
            .navigationBarTitle("Home")
            .toolbar(content: {
                Button(action: {
                    
                }, label: {
                    Image(systemName: "exit")
                })
            })
        }
    }
}

struct CardListView: View {
    let movies: [Movie]
    let title: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
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
                                            .cornerRadius(10)
                                            .clipped()
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
            Image(movie.preview)
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fill)
                .frame(width: 300, height: 170)
                .clipped()
                .cornerRadius(5)
                .shadow(radius: 5)
            VStack(alignment: .leading, spacing: 5) {
                Text(movie.title)
                    .foregroundColor(.primary)
                    .font(.custom("Dosis-Bold", size: 20))
                Text(movie.description)
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
        TabbedPageView().environmentObject(MoviesViewModel())
    }
}
