//
//  HomeViewModel.swift
//  Tango
//
//  Created by Глеб Бурштейн on 01.11.2020.
//

import Foundation

final class MoviesListViewModel: ObservableObject {
//    @Published private(set) var state = State.idle
    
    @Published var genres = [Genre]()
    
    @Published var movies = [Int: [Movie]]()
//        [Movie(title: "Clockwork Orange", poster_path: "https://image.tmdb.org/t/p/w500/tnAuB8q5vv7Ax9UAEje5Xi4BXik.jpg", video: "https://bit.ly/swswift", overview: "Interesting film", genre_ids: [], duration: 5),
//         Movie(title: "Satantango", poster_path: "Satantango", video: "https://bit.ly/swswift", overview: "Our main film ;)", genre_ids: [], duration: 5),
//         Movie(title: "Dogville", poster_path: "Dogville", video: "https://bit.ly/swswift", overview: "Dogville is a 2003 avant-garde crime tragedy film written and directed by Lars von TrierDogville is a 2003 avant-garde crime tragedy film written and directed by Lars von TrierDogville is a 2003 avant-garde crime tragedy film written and directed by Lars von TrierDogville is a 2003 avant-garde crime tragedy film written and directed by Lars von TrierDogville is a 2003 avant-garde crime tragedy film written and directed by Lars von Trier", genre_ids: [], duration: 5),
//         Movie(title: "Satantango", poster_path: "Satantango", video: "https://bit.ly/swswift", overview: "Our main film ;)", genre_ids: [], duration: 5),
//         Movie(title: "Satantango", poster_path: "Satantango", video: "https://bit.ly/swswift", overview: "Our main film ;)", genre_ids: [], duration: 5),]
    
    
    
    public func getGenres() {
        MoviesAPI().getGenres { (genres) in
            self.genres = genres
        }
    }
    
    public func getMovies(genre: Int) {
        MoviesAPI().getMoviesFromGenre(genre: genre) { (movies) in
            self.movies[genre] = movies
        }
    }
}

//extension MoviesListViewModel {
//    enum State {
//        case idle
//        case loading
//        case loaded([Movie])
//        case error(Error)
//    }
//
//    enum Event {
//        case onAppear
//        case onSelectMovie(Int)
//        case onMoviesLoaded([Movie])
//        case onFailedToLoadMovies(Error)
//    }
//}
//
//extension MoviesListViewModel {
//    static func reduce(_ state: State, _ event: Event) -> State {
//        switch state {
//            case .idle:
//                switch event {
//                case .onAppear:
//                    return .loading
//                default:
//                    return state
//                }
//
//            case .loading:
//                switch event {
//                case .onFailedToLoadMovies(let error):
//                    return .error(error)
//                case .onMoviesLoaded(let movies):
//                    return .loaded(movies)
//                default:
//                    return state
//                }
//
//            case .loaded:
//                return state
//            case .error:
//                return state
//        }
//    }
//}



