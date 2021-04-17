//
//  TangoApp.swift
//  Tango
//
//  Created by Глеб Бурштейн on 31.10.2020.
//

import SwiftUI

@main
struct TangoApp: App {
    var body: some Scene {
        WindowGroup {
            RegistrationView()
        }
    }
}

struct TangoApp_Previews: PreviewProvider {
    static var previews: some View {
        TabbedPageView()
    }
}
