//
//  TangoApp.swift
//  Tango
//
//  Created by Глеб Бурштейн on 31.10.2020.
//

import SwiftUI

@main
struct TangoApp: App {
    @State var showSplashScreen: Bool = true
    
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}

struct TangoApp_Previews: PreviewProvider {
    static var previews: some View {
        TabbedPageView()
    }
}
