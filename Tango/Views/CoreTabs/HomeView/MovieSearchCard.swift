//
//  MovieSearchCard.swift
//  Tango
//
//  Created by Глеб Бурштейн on 26.04.2021.
//

import SwiftUI

struct MovieSearchCard: View {
    let movie: Movie
    var body: some View {
        NavigationLink(
            destination: MoviePage(movie: movie),
            label: {
                Poster(poster: movie.posterPath, size: .medium) {
                    ProgressView()
                }
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 150)
                .cornerRadius(5)
                .shadow(radius: 8)
                .animation(.easeInOut)
                VStack {
                    Text(movie.title)
                        .font(.custom("Dosis-Bold", size: 16))
                    Text(movie.overview)
                        .font(.custom("Dosis-Light", size: 12))
                        .lineLimit(3)
                    HStack {
                        PopularityBadge(score: Int(movie.voteAverage) * 10)
                        Text(movie.getReleaseDate).font(.custom("Dosis-Light", size: 12))
                    }
                }
            })
    }
}
