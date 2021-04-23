//
//  HomeViewModel.swift
//  Tango
//
//  Created by Глеб Бурштейн on 01.11.2020.
//

import Foundation
import Combine
import SwiftUI

final class MoviesListViewModel: ObservableObject {
    @Published var state = State.idle
    
    @Published var genres = [Genre]()
    @Published var movies = [Int: [Movie]]()
    
    private var cancellables = Set<AnyCancellable>()
    
    private func getMovies(from genre: Int) {
        MoviesAPI.shared.getMovies(from: genre)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    self.state = .error(error)
                } else {
                    if self.genres[self.genres.count - 1].id == genre {
                        self.state = .loaded(self.movies)
                    }
                }
            }, receiveValue: { movies in
                self.movies[genre] = movies
            })
            .store(in: &cancellables)
    }
    
    private func getGenres() {
        MoviesAPI.shared.getGenres()
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    self.state = .error(error)
                } else {
                    self.getMovies()
                }
            }) { genres in
                self.genres = genres
            }
            .store(in: &cancellables)
    }
    
    private func getMovies() {
        for genre in genres {
            getMovies(from: genre.id)
        }
    }
    
    
    public func fetchData() {
        self.state = .loading
        getGenres()
    }
    
    deinit {
        for cancel in cancellables {
            cancel.cancel()
        }
    }
}

extension MoviesListViewModel {
    enum State {
        case idle
        case loading
        case loaded([Int: [Movie]])
        case error(Error)
    }
}

