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
            if showSplashScreen {
                ZStack {
                    Color.white.edgesIgnoringSafeArea(.all)
                    Image("tango")
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.showSplashScreen = false
                    }
                }
                .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5)))
                .zIndex(1)
            } else {
                TabbedPageView()
            }
        }
    }
}

struct TangoApp_Previews: PreviewProvider {
    static var previews: some View {
        TabbedPageView()
    }
}
