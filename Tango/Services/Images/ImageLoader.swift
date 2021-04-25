//
//  ImageLoader.swift
//  Tango
//
//  Created by Глеб Бурштейн on 24.04.2021.
//

import Combine
import SwiftUI
import UIKit

class ImageCache {
    var cache = NSCache<NSURL, UIImage>()
    
    func get(forKey: NSURL) -> UIImage? {
        return cache.object(forKey: forKey)
    }
    
    func set(forKey: NSURL, image: UIImage?) {
        if let image = image {
            cache.setObject(image, forKey: forKey)
        }
    }
}

extension ImageCache {
    private static var imageCache = ImageCache()
    static func getImageCache() -> ImageCache {
        return imageCache
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
    private var cache: ImageCache = ImageCache.getImageCache()
    private var cancellable: AnyCancellable?
    
    let url: URL
    
    @Published var image: UIImage?
    init(poster: String, size: Size) {
        self.url = size.path(poster: poster)
    }
    
    public func loadImage() {
        
        if let image = cache.get(forKey: url as NSURL) {
            self.image = image
            print("Cache hit!")
            return
        }
        
        print("Cache miss!")
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {
                self.cache.set(forKey: self.url as NSURL, image: $0)
                self.image = $0
            })
    }
    
    deinit {
        cancellable?.cancel()
    }
}
