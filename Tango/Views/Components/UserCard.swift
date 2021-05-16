//
//  UserCard.swift
//  Tango
//
//  Created by Глеб Бурштейн on 14.05.2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserCard: View {
    @Environment(\.colorScheme) var colorScheme
    
    let user: User
    var body: some View {
        HStack {
            WebImage(url: URL(string: user.avatar ?? ""))
                .placeholder(Image("avatar"))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            
            Text(user.username)
                .font(.custom("Dosis-Regular", size: 24))
            Spacer()
        }
        .foregroundColor(colorScheme == .dark ? .AccentColorLight: .AccentColorDark)
    }
}
