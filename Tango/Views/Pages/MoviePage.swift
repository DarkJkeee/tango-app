//
//  MoviePage.swift
//  Tango
//
//  Created by Глеб Бурштейн on 20.12.2020.
//

import SwiftUI
import Kingfisher
import AVKit

struct MoviePage: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    var movie: Movie
    
    var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ZStack(alignment: .bottom) {
                        KFImage(URL(string: "https://image.tmdb.org/t/p/w500" + (movie.posterPath ?? ""))!)
                            .placeholder({ProgressView()})
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(5)
                        Rectangle()
                            .frame(height: 80)
                            .opacity(0.25)
                            .blur(radius: 10)
                    }
                    MovieDescription(movie: movie)
                }
            }
            .background(colorScheme == .dark ? Color.backgroundColorDark : Color.backgroundColorLight)
            .edgesIgnoringSafeArea(.all)
//            .navigationBarItems(leading: Button(action: {
//                presentationMode.wrappedValue.dismiss()
//            }, label: {
//                HStack {
//                    Image(systemName: "arrow.left")
//                    Text("Back")
//                }
//            }))
    }
}

struct MovieDescription: View {
    @Environment(\.colorScheme) var colorScheme
    let movie: Movie
    
    @State var isExpanded: Bool = false
    @State var truncated: Bool = false
    @State var isInWishList: Bool = false
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 15) {
            
            Text(movie.title)
                .foregroundColor(colorScheme == .dark ? .AccentColorLight : .AccentColorDark)
                .font(.custom("Dosis-Bold", size: 35))
                .fontWeight(.semibold)
            Text("1h 44m | Drama | \(movie.getReleaseDate)")
                .foregroundColor(.secondary)
                .font(.custom("Dosis-Regular", size: 16))
            
            BorderedButton(text: isInWishList ? "In Wishlist" : "Wishlist", systemImageName: "heart", color: colorScheme == .dark ? Color("AccentLight") : Color("AccentDark"), isOn: isInWishList, action: {
                // TODO: adds to wl.
                isInWishList.toggle()
            })
            
            Text(movie.overview)
                .font(.custom("Dosis-Regular", size: 24))
                .lineLimit(isExpanded ? nil : 5)
                .background(
                    Text(movie.overview).lineLimit(5)
                        .background(GeometryReader { displayedGeometry in
                            ZStack {
                                Text(movie.overview)
                                    .background(GeometryReader { fullGeometry in
                                        Color.clear.onAppear {
                                            self.truncated = fullGeometry.size.height > displayedGeometry.size.height
                                        }
                                    })
                            }
                            .frame(height: .greatestFiniteMagnitude)
                        })
                        .hidden()
                )
            if truncated {
                
                Button(action: { self.isExpanded.toggle() }) {
                    Text(isExpanded ? "Show less" : "Show more")
                        .foregroundColor(colorScheme == .dark ? .AccentColorLight : .AccentColorDark)
                        .font(.custom("Dosis-Bold", size: 16))
                }
            }
            
        }
        .padding(.all)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
}
