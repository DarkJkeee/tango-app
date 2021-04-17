//
//  SearchView.swift
//  Tango
//
//  Created by Глеб Бурштейн on 05.02.2021.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var searchVM = SearchViewModel()
    @State var text: String = ""
    @State private var isEditing = false
    
    var body: some View {
        VStack {
            ScrollView {
                TextField("Search ...", text: $text, onCommit: {                  searchVM.getSearchResponse(query: text)
                })
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                ForEach(searchVM.movies) { movie in
                    NavigationLink(
                        destination: MoviePage(movie: movie),
                        label: {
                            MovieCardView(movie: movie)
                        })
                }.padding()
            }
            .padding(.top, 40)
            Spacer()
        }
        .padding()
        .background(Color("Background"))
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .preferredColorScheme(.dark)
    }
}
