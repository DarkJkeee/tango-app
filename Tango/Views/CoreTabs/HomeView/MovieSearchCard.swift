//
//  MovieSearchCard.swift
//  Tango
//
//  Created by Глеб Бурштейн on 26.04.2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieSearchCard: View {
    @EnvironmentObject var profileVM: ProfileViewModel
    let movie: Movie
    var body: some View {
        NavigationLink(
            destination: MoviePage(movie: movie).environmentObject(profileVM),
            label: {
                WebImage(url: URL(string: movie.descPreview))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 150)
                    .cornerRadius(5)
                    .shadow(radius: 8)
                    .animation(.easeInOut)
                
                VStack {
                    Text(movie.title)
                        .font(.custom("Dosis-Bold", size: 16))
                    Text(movie.descText)
                        .font(.custom("Dosis-Light", size: 12))
                        .lineLimit(3)
                    HStack {
                        PopularityBadge(score: Int(movie.descRating) * 10)
//                        Text(movie.getReleaseDate).font(.custom("Dosis-Light", size: 12))
                    }
                }
            })
    }
}
