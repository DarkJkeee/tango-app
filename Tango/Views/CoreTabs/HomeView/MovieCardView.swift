//
//  MovieCardView.swift
//  Tango
//
//  Created by Глеб Бурштейн on 04.11.2020.
//

import SwiftUI

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
                    .font(.headline)
                Text(movie.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .frame(height: 40)
            }
        }
    }
}

struct MovieCardView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
