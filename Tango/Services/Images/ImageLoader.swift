//
//  ImageLoader.swift
//  Tango
//
//  Created by Глеб Бурштейн on 24.04.2021.
//

import Foundation
import Combine
import UIKit

protocol ImageCache {
    subscript(_ url: URL) -> UIImage? { get set }
}

struct TemporaryImageCache: ImageCache {
    private let cache = NSCache<NSURL, UIImage>()
    
    subscript(_ key: URL) -> UIImage? {
        get { cache.object(forKey: key as NSURL) }
        set { newValue == nil ? cache.removeObject(forKey: key as NSURL) : cache.setObject(newValue!, forKey: key as NSURL) }
    }
}

enum Size: String {
    case small = "https://image.tmdb.org/t/p/w154"
    case medium = "https://image.tmdb.org/t/p/w500"
    case cast = "https://image.tmdb.org/t/p/w185"
    case original = "https://image.tmdb.org/t/p/original"
    
    func path(poster: String) -> URL {
        return URL(string: rawValue)!.appendingPathComponent(poster)
    }
}

class ImageLoader : ObservableObject {
    private var cache: ImageCache?
    private var cancellable: AnyCancellable?
    
    let size: Size
    let path: String?
    
    @Published var image: UIImage?
    init(path: String?, size: Size, cache: ImageCache? = nil) {
        self.size = size
        self.path = path
        self.cache = cache
    }
    
    public func loadImage() {
        guard let poster = path, image == nil else {
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: size.path(poster: poster))
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
        
    }
    
    deinit {
        cancellable?.cancel()
    }
}
