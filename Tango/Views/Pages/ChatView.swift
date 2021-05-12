//
//  ChatView.swift
//  Tango
//
//  Created by Глеб Бурштейн on 03.04.2021.
//

import SwiftUI

struct ChatView: View {
    var messages: [Message]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                ForEach(self.messages) { message in
                     MessageView(message: message)
                        .padding(.horizontal, 8)
                        .padding(EdgeInsets(
                                    top: 0,
                                    leading: message.sender == .me ? geometry.size.width * 0.5 : 0 ,
                                    bottom: 0,
                                    trailing: message.sender == .me ? 0 : geometry.size.width * 0.5))
                }
            }
        }
    }
}
