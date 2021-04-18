//
//  HomeViewModel.swift
//  Tango
//
//  Created by Глеб Бурштейн on 01.11.2020.
//

import Foundation
import Combine

final class MoviesListViewModel: ObservableObject {
    @Published private(set) var state = State.loading
    
    @Published var genres = [Genre]()
    @Published var movies = [Int: [Movie]]()
    
    private var cancellables = Set<AnyCancellable>()
    
    
    private func getMovies(from genre: Int) {
        MoviesAPI.shared.getMovies(from: genre)
            .replaceError(with: [])
            .sink(receiveValue: { movies in
                self.movies[genre] = movies
            })
            .store(in: &cancellables)
    }
    
    public func getGenres() {
        MoviesAPI.shared.getGenres { (genres) in
            self.genres = genres
        }
    }
    
    public func getMovies() {
        self.state = .loading
        for genre in genres {
            getMovies(from: genre.id)
        }
        self.state = .loaded(movies)
    }
    
    
}




extension MoviesListViewModel {
    enum State {
        case idle
        case loading
        case loaded([Int: [Movie]])
        case error(Error)
    }

    enum Event {
        case onAppear
        case onSelectMovie(Int)
        case onMoviesLoaded([Int: [Movie]])
        case onFailedToLoadMovies(Error)
    }
}

extension MoviesListViewModel {
    static func reduce(_ state: State, _ event: Event) -> State {
        switch state {
            case .idle:
                switch event {
                case .onAppear:
                    return .loading
                default:
                    return state
                }

            case .loading:
                switch event {
                case .onFailedToLoadMovies(let error):
                    return .error(error)
                case .onMoviesLoaded(let movies):
                    return .loaded(movies)
                default:
                    return state
                }

            case .loaded:
                return state
            case .error:
                return state
        }
    }
}



