//
//  Message.swift
//  Tango
//
//  Created by Глеб Бурштейн on 10.05.2021.
//

import Foundation

struct Message: Hashable, Identifiable {

     let id = UUID()
     let sender: String
     let content: String
}
