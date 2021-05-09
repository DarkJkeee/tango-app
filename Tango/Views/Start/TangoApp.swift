//
//  TangoApp.swift
//  Tango
//
//  Created by Глеб Бурштейн on 31.10.2020.
//

import LocalAuthentication
import SwiftUI

@main
struct TangoApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    @StateObject var sessionVM = SessionViewModel()
    @StateObject var profileVM = ProfileViewModel()
    
    var body: some Scene {
        WindowGroup {
            VStack {
                if !sessionVM.isLogged {
                    LoginView()
                } else {
                    TabbedPageView()
                        .onAppear() {
                            profileVM.loadProfileWith(id: sessionVM.userId)
                        }
                }
            }
            .environmentObject(sessionVM)
            .environmentObject(profileVM)
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .accentColor(isDarkMode ? .AccentColorLight : .AccentColorDark)
            .onAppear() {
                UIApplication.shared.addTapGestureRecognizer()
                if sessionVM.token != "" {
                    sessionVM.authenticateWithoutPass()
                }
            }
        }
    }
}

extension UIApplication {
    func addTapGestureRecognizer() {
        guard let window = windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true // set to `false` if you don't want to detect tap during other gestures
    }
}
