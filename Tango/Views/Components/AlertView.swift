//
//  AlertView.swift
//  Tango
//
//  Created by Глеб Бурштейн on 23.04.2021.
//

import SwiftUI

struct AlertView: View {
    var error: Error
    
    @State private var isAlert = false
    
    var body: some View {
        ZStack {
            Color("Background")
            Button(action: {
                isAlert = true
            }) {
                Text("Failed to load data!\nClick to more info")
                    .foregroundColor(Color("Background"))
            }
            .padding()
            .background(Color("AccentColor"))
            .cornerRadius(10)
            .alert(isPresented: $isAlert) { () -> Alert in
                Alert(title: Text("Error"), message: Text(error.localizedDescription), dismissButton: Alert.Button.default(Text("Okay")))
            }
        }
    }
}


struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView(error: MoviesAPIError.genericError)
    }
}
