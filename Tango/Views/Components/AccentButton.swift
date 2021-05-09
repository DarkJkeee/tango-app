//
//  AccentButton.swift
//  Tango
//
//  Created by Глеб Бурштейн on 09.05.2021.
//

import SwiftUI

struct AccentButton: View {
    @Environment(\.colorScheme) var colorScheme
    
    var title: String
    var width: CGFloat?
    var height: CGFloat?
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: width, height: height)
                .overlay(
                    Text(title)
                        .font(.custom("Dosis-Bold", size: 20))
                        .foregroundColor(colorScheme == .dark ? .AccentColorDark : .AccentColorLight)
                )
        })
        .padding()
    }
}
