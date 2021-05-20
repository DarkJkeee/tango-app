//
//  MessageView.swift
//  Tango
//
//  Created by Глеб Бурштейн on 10.05.2021.
//

import SwiftUI

struct MessageView: View {
    @EnvironmentObject var profileVM: ProfileViewModel
    @Environment(\.colorScheme) var colorScheme
    let message: MessageDTO

    var body: some View {
        HStack {
            if message.username == profileVM.mainUser.username {
                Spacer()
            }

            VStack(alignment: message.username == profileVM.mainUser.username ? .trailing : .leading) {
                Text(message.username)
                    .font(.custom("Dosis-Bold", size: 18))
                    .foregroundColor(colorScheme == .dark ? .white : .AccentColorDark)
                Text(message.message ?? "")
                    .font(.custom("Dosis-Regular", size: 20))
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(message.username == profileVM.mainUser.username ? colorScheme == .dark ? .AccentLight : .AccentDark : Color.gray)
                    .cornerRadius(16)
            }
            .foregroundColor(message.username == profileVM.mainUser.username ? colorScheme == .dark ? .AccentColorDark : .white : Color.black)

            if message.username != profileVM.mainUser.username {
                Spacer()
            }
        }
    }
}
