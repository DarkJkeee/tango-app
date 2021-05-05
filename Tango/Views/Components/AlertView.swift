//
//  AlertView.swift
//  Tango
//
//  Created by Глеб Бурштейн on 23.04.2021.
//

import SwiftUI

struct AlertView: View {
    @AppStorage("isDarkMode") var isDarkMode = false
    var error: Error
    var retryAction: () -> Void
    
    @State private var isAlert = false
    
    var body: some View {
        VStack {
            Button(action: {
                isAlert = true
            }) {
                Text("Failed to load data!\nClick to more info")
                    .foregroundColor(isDarkMode ? Color.backgroundColorDark : Color.backgroundColorLight)
            }
            .padding()
            .background(isDarkMode ? Color.AccentColorLight : Color.AccentColorDark)
            .cornerRadius(10)
            .alert(isPresented: $isAlert) { () -> Alert in
                Alert(title: Text("Error"), message: Text(error.localizedDescription), dismissButton: Alert.Button.default(Text("Okay")))
            }
            Button(action: {
                retryAction()
            }, label: {
                Text("Retry")
            })
            .padding()
        }
    }
}


struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView(error: MoviesAPIError.genericError, retryAction: { })
    }
}
