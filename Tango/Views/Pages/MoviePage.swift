//
//  MoviePage.swift
//  Tango
//
//  Created by Глеб Бурштейн on 20.12.2020.
//

import URLImage
import SwiftUI
import AVKit

struct MoviePage: View {
    var movie: Movie
    @State var isPressed = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ZStack(alignment: .bottom) {
                        URLImage(url: URL(string: "https://image.tmdb.org/t/p/w500" + (movie.poster_path ?? "/tnAuB8q5vv7Ax9UAEje5Xi4BXik.jpg"))!) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(5)
                        }
                        Rectangle()
                            .frame(height: 80)
                            .opacity(0.25)
                            .blur(radius: 10)
                    }
                    MovieDescription(movie: movie)
                }
                .edgesIgnoringSafeArea(.top)
            }
            .navigationBarHidden(true)
        }
    }
}

struct MovieDescription: View {
    let movie: Movie
    
    @State var isExpanded: Bool = false
    @State var truncated: Bool = false
    @State var isInWishList: Bool = false
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 15) {
            
            Text(movie.title)
                .foregroundColor(.primary)
                .font(.custom("Dosis-Bold", size: 35))
                .fontWeight(.semibold)
            Text("1h 44m | Drama | 3 July 2003")
                .foregroundColor(.secondary)
                .font(.custom("Dosis-Regular", size: 16))
            
            BorderedButton(text: isInWishList ? "In Wishlist" : "Wishlist", systemImageName: "heart", color: .green, isOn: isInWishList, action: {
                MoviesAPI().setMovieToWishlist(movie: movie)
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
                        .font(.custom("Dosis-Bold", size: 16))
                }
            }
            HStack {
                Spacer()
                    NavigationLink(
                        destination: Player(player: AVPlayer(url: URL(string: "https://bit.ly/swswift")!)),
                        label: {
                            Text("Watch")
                        })
                Spacer()
            }
        }
        .padding(.all)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
}





//struct MoviePage_Previews: PreviewProvider {
//    static var previews: some View {
//        MoviePage(movie: Movie(title: "Dogville", poster_path: "Dogville", video: "", overview: "interestinterestfildsadasdasdasdasdasdasdasdasdasdasdminterestfildsadasdasdasdasdasdasdasdasdasdasdminterestfildsadasdasdasdasdasdasdasdasdasdasdminterestfildsadasdasdasdasdasdasdasdasdasdasdminterestfildsadasdasdasdasdasdasdasdasdasdasdmfildsadasdasdasdasdasdasdasdasdasdasdminterest", genre_ids: [], duration: 5))
//            .preferredColorScheme(.dark)
//    }
//}
