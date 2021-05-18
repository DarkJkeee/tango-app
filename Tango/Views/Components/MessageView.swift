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

            VStack {
                Text(message.sender)
                Text(message.content)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(message.sender == profileVM.mainUser.username ? colorScheme == .dark ? .AccentLight : .AccentDark : Color.gray)
                    .foregroundColor(message.sender == profileVM.mainUser.username ? colorScheme == .dark ? .AccentColorDark : .AccentColorLight : Color.black)
                    .cornerRadius(16)
            }

            if message.sender != profileVM.mainUser.username {
                Spacer()
            }
        }
    }
}
