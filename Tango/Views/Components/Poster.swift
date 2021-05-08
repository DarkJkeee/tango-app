//
//  Poster.swift
//  Tango
//
//  Created by Глеб Бурштейн on 25.04.2021.
//

import SwiftUI

struct Poster<Placeholder: View> : View {
    @State var failed = false
    @ObservedObject private var loader: ImageLoader
    private let placeholder: Placeholder
    
    init(poster: String?, size: Size, @ViewBuilder placeholder: () -> Placeholder) {
        self.placeholder = placeholder()
        loader = ImageLoader(poster: poster ?? "", size: size)
    }
    
    var body: some View {
        content
            .onAppear() {
                loader.loadImage()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    if loader.image == nil {
                        failed = true
                    }
                }
            }
    }
    
    private var content: some View {
        Group {
            if loader.image != nil {
                Image(uiImage: loader.image!)
                    .resizable()
            } else if failed {
                Image("tango")
                    .resizable()
            } else {
                placeholder
            }
        }
    }
    
}
