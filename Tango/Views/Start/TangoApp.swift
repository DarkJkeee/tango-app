//
//  TangoApp.swift
//  Tango
//
//  Created by Глеб Бурштейн on 31.10.2020.
//

import SwiftUI

@main
struct TangoApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    var body: some Scene {
        WindowGroup {
            RegistrationView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}

struct TangoApp_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RegistrationView().previewDevice("iPhone 12 Pro Max")
            RegistrationView().previewDevice("iPhone SE (2nd generation)")
                .preferredColorScheme(.dark)
            RegistrationView().previewDevice("iPod touch (7th generation)")
        }
    }
}
