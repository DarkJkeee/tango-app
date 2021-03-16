//
//  MoviePage.swift
//  Tango
//
//  Created by Глеб Бурштейн on 20.12.2020.
//

import SwiftUI

struct MoviePage: View {
    var movie: Movie
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                ZStack(alignment: .bottom) {
                    Image(movie.preview)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Rectangle()
                        .frame(height: 80)
                        .opacity(0.25)
                        .blur(radius: 10)
                }
                MovieDescription(movie: movie)
                
            }
            .edgesIgnoringSafeArea(.top)
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
                isInWishList.toggle()
            })
            
            Text(movie.description)
                .font(.custom("Dosis-Regular", size: 24))
                .lineLimit(isExpanded ? nil : 5)
                .background(
                    Text(movie.description).lineLimit(5)
                        .background(GeometryReader { displayedGeometry in
                            ZStack {
                                Text(movie.description)
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
        }
        .padding(.all)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
}


struct MoviePage_Previews: PreviewProvider {
    static var previews: some View {
        MoviePage(movie: Movie(title: "Dogville", preview: "Dogville", video: "", description: "interestinterestfildsadasdasdasdasdasdasdasdasdasdasdminterestfildsadasdasdasdasdasdasdasdasdasdasdminterestfildsadasdasdasdasdasdasdasdasdasdasdminterestfildsadasdasdasdasdasdasdasdasdasdasdminterestfildsadasdasdasdasdasdasdasdasdasdasdmfildsadasdasdasdasdasdasdasdasdasdasdminterest", genre: "Drama", tags: [""], duration: 5))
    }
}
