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
    let message: Message

    var body: some View {
        HStack {
            if message.sender == profileVM.mainUser.username {
                Spacer()
            }

            VStack(alignment: message.sender == profileVM.mainUser.username ? .trailing : .leading) {
                Text(message.sender)
                    .font(.custom("Dosis-Bold", size: 18))
                    .foregroundColor(colorScheme == .dark ? .white : .AccentColorDark)
                Text(message.content)
                    .font(.custom("Dosis-Regular", size: 20))
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(message.sender == profileVM.mainUser.username ? colorScheme == .dark ? .AccentLight : .AccentDark : Color.gray)
                    .cornerRadius(16)
            }
            .foregroundColor(message.sender == profileVM.mainUser.username ? colorScheme == .dark ? .AccentColorDark : .white : Color.black)

            if message.sender != profileVM.mainUser.username {
                Spacer()
            }
        }
    }
}
