//
//  Message.swift
//  Tango
//
//  Created by Глеб Бурштейн on 10.05.2021.
//

import Foundation

struct Message: Hashable, Identifiable {
     enum Sender: Hashable {
          case me
          case other(named: String)
     }

     let id: Int
     let sender: Sender
     let content: String
}
