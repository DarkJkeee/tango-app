//
//  CardListView.swift
//  Tango
//
//  Created by Глеб Бурштейн on 26.04.2021.
//

import SwiftUI

struct CardListView: View {
    @Environment(\.colorScheme) var colorScheme
    let movies: [Movie]
    let genre: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(genre)
                .font(.custom("Dosis-Bold", size: 26))
                .foregroundColor(colorScheme == .dark ? .AccentColorLight : .AccentColorDark)
                .padding(.leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top) {
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
