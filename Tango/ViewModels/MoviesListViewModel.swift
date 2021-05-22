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
    @Published var searchState = SearchState.idle
    
    @Published var searchText: String = ""
    @Published var genres = [Genre]()
    private var movies = [Int: [MovieDTO]]()
    
//    private var movies = [Int: [Movie]]()
    
    private var cancellables = Set<AnyCancellable>()
    
    init () {
        $searchText
            .dropFirst()
            .removeDuplicates()
            .map { str -> String? in
                if (str.count < 1) {
                    self.searchState = .idle
                    return nil
                }
            
                return str
            }
            .compactMap { $0 }
            .sink { query in
                self.searchData(query: query)
            }
            .store(in: &cancellables)
    }
    
    private func getMovies(from genre: Int?) {
        MoviesAPI.shared.GetMovies(from: genre)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    self.state = .error(error)
                } else {
                    self.state = .loaded(self.movies)
                }
            }, receiveValue: { movies in
                self.movies[genre ?? 0] = movies
            })
            .store(in: &cancellables)
    }
    
//    private func getMovies(from genre: Int) {
//        MoviesAPI.shared.getMovies(from: genre)
//            .sink(receiveCompletion: { completion in
//                if case let .failure(error) = completion {
//                    self.state = .error(error)
//                } else {
//                    self.state = .loaded(self.movies)
//                }
//            }, receiveValue: { movies in
//                self.movies[genre] = movies
//            })
//            .store(in: &cancellables)
//    }
    
    private func getGenres() {
        MoviesAPI.shared.getGenres()
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    self.state = .error(error)
                } else {
                    for genre in self.genres {
                        self.getMovies(from: genre.id)
                    }
                }
            }) { genres in
                self.genres = genres
            }
            .store(in: &cancellables)
    }
    
//    private func getMovies() {
//        for genre in genres {
//            getMovies(from: genre.id)
//        }
//    }
    
    private func searchData(query: String) {
        MoviesAPI.shared.getSearchRepsonse(query: query)
            .sink { (completion) in
                if case .failure(let error) = completion {
                    self.searchState = .error(error)
                }
            } receiveValue: { movies in
                self.searchState = .loaded(movies)
            }
            .store(in: &cancellables)
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
        case loaded([Int: [MovieDTO]])
        case error(Error)
    }
    enum SearchState {
        case idle
        case loaded([MovieDTO])
        case error(Error)
    }
}

