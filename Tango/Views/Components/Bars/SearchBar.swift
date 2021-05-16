//
//  SearchBar.swift
//  Tango
//
//  Created by Глеб Бурштейн on 27.04.2021.
//

import SwiftUI

struct SearchBar: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var text: String
 
    @State private var isEditing = false
    var placeholder: String
 
    var body: some View {
        HStack {
 
            HStack(spacing: 15) {
                Image(systemName: "magnifyingglass")
                
                ZStack(alignment: .leading) {
                    if text.isEmpty { Text(placeholder).opacity(0.6) }
                        TextField("", text: $text)
                            .autocapitalization(.none)
                }
            }
            .padding()
            .cornerRadius(8)
 
            if !text.isEmpty {
                Button(action: {
                    text = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }, label: {
                    Image(systemName: "x.circle.fill")
                })
                .padding(.trailing, 15)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
        .foregroundColor(colorScheme == .dark ? Color.AccentColorLight : Color.AccentColorDark)
    }
}
