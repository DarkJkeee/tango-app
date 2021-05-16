//
//  MovieCardView.swift
//  Tango
//
//  Created by Глеб Бурштейн on 26.04.2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieCardView: View {
    @Environment(\.colorScheme) var colorScheme
    let movie: Movie
    
    var lairDiagonalDarkBorder: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [.white, .lairGray]),
            startPoint: UnitPoint(x: -0.2, y: 0.5),
            endPoint: .bottomTrailing
        )
    }
    
    var lairDiagonalLightBorder: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [.white, .lairLightGray]),
            startPoint: UnitPoint(x: 0.2, y: 0.2),
            endPoint: .bottomTrailing
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            WebImage(url: URL(string: movie.descPreview))
                .placeholder {
                    ProgressView()
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 300, height: 170)
                .clipped()
                .shadow(color: .white, radius: 2, x: -3, y: -3)
                .shadow(color: .lairShadowGray, radius: 2, x: 3, y: 3)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
    //                    .stroke(colorScheme == .dark ? lairDiagonalLightBorder : lairDiagonalDarkBorder, lineWidth: 1)
                        .stroke(lairDiagonalDarkBorder, lineWidth: 1)
                )
                .background(Color.lairBackgroundGray)
                .cornerRadius(10)
                .contextMenu {
                    Button(action: {
                        
                    }, label: {
                        Text("Add to wishlist")
                    })
                }
            VStack(alignment: .leading, spacing: 5) {
                Text(movie.title)
                    .foregroundColor(colorScheme == .dark ? .AccentColorLight : .AccentColorDark)
                    .font(.custom("Dosis-Bold", size: 20))
                Text(movie.descText)
                    .font(.custom("Dosis-Regular", size: 15))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .frame(height: 40)
            }
        }
    }
}
