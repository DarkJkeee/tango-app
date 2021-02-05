//
//  HomeViewModel.swift
//  Tango
//
//  Created by Глеб Бурштейн on 01.11.2020.
//

import Foundation

class MoviesViewModel: ObservableObject {
    
    // @Published var genres: [Genre]
    
    @Published var movies: [Movie] =
        [Movie(title: "Clockwork Orange", preview: "Clockwork orange", video: "Some url", description: "Interesting film", genre: "Crime", tags: ["Blood", "rigidity"]),
         Movie(title: "Satantango", preview: "Satantango", video: "Some url", description: "Our main film ;)", genre: "Comedy", tags: ["Drama", "Comedy", "W/B"]),
         Movie(title: "Dogville", preview: "Dogville", video: "Some url", description: "Dogville is a 2003 avant-garde crime tragedy film written and directed by Lars von Trier", genre: "Tragedy", tags: [""]),
         Movie(title: "Satantango", preview: "Satantango", video: "Some url", description: "Our main film ;)", genre: "Comedy", tags: ["Drama", "Comedy", "W/B"]),
         Movie(title: "Satantango", preview: "Satantango", video: "Some url", description: "Our main film ;)", genre: "Comedy", tags: ["Drama", "Comedy", "W/B"]),]
    
    
}
