//
//  MoviePageViewModel.swift
//  Tango
//
//  Created by Глеб Бурштейн on 18.05.2021.
//

import Foundation
import Combine

class MoviePageViewModel: ObservableObject {
    
    @Published var currentComments = [Comment]()
    @Published var review: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    public func getComments(id: Int) {
        MoviesAPI.shared.getComments(id: id)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { result in
                self.currentComments = result
            }
            .store(in: &cancellables)
    }
    
    public func addCommment(id: Int) {
        MoviesAPI.shared.leaveComment(filmId: id, userId: Session.shared.userId, text: review)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { result in
                self.currentComments.insert(result, at: 0)
            }
            .store(in: &cancellables)
    }
    
    public func deleteComment(id: Int) {
        MoviesAPI.shared.deleteComment(id: id)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { result in
                if result == "OK" {
                    self.currentComments.remove(at: self.currentComments.firstIndex(where: { comment in
                        comment.id == id
                    }) ?? 0)
                }
            }
            .store(in: &cancellables)
    }
    
    public func like(id: Int) {
        MoviesAPI.shared.getComments(id: id)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { result in
                self.currentComments = result
            }
            .store(in: &cancellables)
    }
    
    public func dislike(id: Int) {
        MoviesAPI.shared.getComments(id: id)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { result in
                self.currentComments = result
            }
            .store(in: &cancellables)
    }
    
    deinit {
        for cancellable in cancellables {
            cancellable.cancel()
        }
    }
}
