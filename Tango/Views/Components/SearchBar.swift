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
 
    var body: some View {
        HStack {
 
            HStack(spacing: 15) {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .foregroundColor(colorScheme == .dark ? Color.AccentColorLight.opacity(0.3) : Color.AccentColorDark.opacity(0.3))
                
                TextField("Search", text: $text)
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
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
    }
}
