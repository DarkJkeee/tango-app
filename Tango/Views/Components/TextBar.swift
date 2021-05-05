//
//  TextBar.swift
//  Tango
//
//  Created by Глеб Бурштейн on 04.05.2021.
//

import SwiftUI

struct TextBar: View {
    @Binding var text: String
    var placeholder: String
    var imageName: String
    var isSecureField: Bool
    
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .autocapitalization(.none)
            } else {
                TextField(placeholder, text: $text)
                    .autocapitalization(.none)
            }
        }
        .padding()
        .cornerRadius(20)
    }
}
