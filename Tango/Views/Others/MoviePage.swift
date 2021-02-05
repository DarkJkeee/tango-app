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
            VStack(alignment: .leading, spacing: 15) {
                Text(movie.title)
                    .foregroundColor(.primary)
                    .font(.title)
                    .fontWeight(.semibold)
                Text("1h 44m | Drama | 3 July 2003")
                    .foregroundColor(.secondary)
                Text(movie.description)
                    .padding(.top)
                
            }
            .padding(.all)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0,maxHeight: .infinity, alignment: .topLeading)
            
            
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct MoviePage_Previews: PreviewProvider {
    static var previews: some View {
        MoviePage(movie: Movie(title: "Dogville", preview: "Dogville", video: "", description: "interest film", genre: "Drama", tags: [""]))
            
    }
}
