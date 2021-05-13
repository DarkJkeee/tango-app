//
//  LoadingScreen.swift
//  Tango
//
//  Created by Глеб Бурштейн on 13.05.2021.
//

import SwiftUI

struct LoadingScreen: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        Rectangle()
            .frame(width: 200, height: 100, alignment: .center)
            .foregroundColor(colorScheme == .dark ? Color.AccentColorDark : Color.AccentColorLight)
            .cornerRadius(10)
        ProgressView("Loading...")
    }
}

struct LoadingScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoadingScreen()
    }
}
