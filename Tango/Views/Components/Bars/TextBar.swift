//
//  TextBar.swift
//  Tango
//
//  Created by Глеб Бурштейн on 04.05.2021.
//

import SwiftUI

struct TextBar: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var text: String
    var placeholder: String
    var imageName: String
    var isSecureField: Bool
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
            ZStack(alignment: .leading) {
                if text.isEmpty { Text(placeholder).opacity(0.6) }
                if isSecureField {
                    SecureField("", text: $text)
                        .autocapitalization(.none)
                } else {
                    TextField("", text: $text)
                        .autocapitalization(.none)
                }
            }
        }
        .padding()
        .cornerRadius(20)
    }
}
