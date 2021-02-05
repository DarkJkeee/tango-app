//
//  CardListView.swift
//  Tango
//
//  Created by Глеб Бурштейн on 04.11.2020.
//

import SwiftUI

struct CardListView: View {
    let movies: [Movie]
    let genre: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(genre)
                .fontWeight(.heavy)
                .font(.system(.body, design: .rounded))
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

struct CardListView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
