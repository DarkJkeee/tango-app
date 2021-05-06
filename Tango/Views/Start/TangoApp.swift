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
    @StateObject var loginVM = LoginViewModel()
    var body: some Scene {
        WindowGroup {
            if !loginVM.isLogged {
                LoginView(loginVM: loginVM)
                    .preferredColorScheme(isDarkMode ? .dark : .light)
                    .accentColor(isDarkMode ? .AccentColorLight : .AccentColorDark)
            } else {
                TabbedPageView()
                    .environmentObject(loginVM)
                    .preferredColorScheme(isDarkMode ? .dark : .light)
                    .accentColor(isDarkMode ? .AccentColorLight : .AccentColorDark)
            }
        }
    }
}

struct TangoApp_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RegistrationView(loginVM: LoginViewModel()).previewDevice("iPhone 12 Pro Max")
                .preferredColorScheme(.dark)
            RegistrationView(loginVM: LoginViewModel()).previewDevice("iPhone SE (2nd generation)")
            RegistrationView(loginVM: LoginViewModel()).previewDevice("iPod touch (7th generation)")
        }
    }
}
