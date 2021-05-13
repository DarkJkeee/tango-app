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
            if message.sender == .me {
                Spacer()
            }

            VStack {
                Text(message.sender == .me ? profileVM.mainUser.username : "other")
                Text(message.content)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(message.sender == .me ? colorScheme == .dark ? .AccentLight : .AccentDark : Color.gray)
                    .foregroundColor(message.sender == .me ? colorScheme == .dark ? .AccentColorDark : .AccentColorLight : Color.black)
                    .cornerRadius(16)
            }

            if message.sender != .me {
                Spacer()
            }
        }
    }
}
