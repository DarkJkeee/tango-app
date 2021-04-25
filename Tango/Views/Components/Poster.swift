//
//  Poster.swift
//  Tango
//
//  Created by Глеб Бурштейн on 25.04.2021.
//

import SwiftUI

struct Poster<Placeholder: View> : View {
    
    @StateObject private var loader: ImageLoader
    private let placeholder: Placeholder
    
    init(poster: String?, size: Size, @ViewBuilder placeholder: () -> Placeholder) {
        self.placeholder = placeholder()
        _loader = StateObject(wrappedValue: ImageLoader(path: poster, size: size))
    }
    
    var body: some View {
        content
            .onAppear() {
                loader.loadImage()
            }
    }
    
    private var content: some View {
        Group {
            if loader.image != nil {
                Image(uiImage: loader.image!)
                    .resizable()
            } else {
                placeholder
            }
        }
    }
    
}
