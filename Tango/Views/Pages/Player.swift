//
//  Player.swift
//  Tango
//
//  Created by Глеб Бурштейн on 28.03.2021.
//

import SwiftUI
import AVKit

struct Player: View {
    var player: AVPlayer
        
    var body: some View {
        VideoPlayer(player: player)
            .onAppear() {
                player.play()
            }
            .edgesIgnoringSafeArea(.all)
            .foregroundColor(.black)
    }
}

