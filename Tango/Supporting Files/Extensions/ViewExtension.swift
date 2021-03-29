//
//  ViewExtension.swift
//  Tango
//
//  Created by Глеб Бурштейн on 28.03.2021.
//

import SwiftUI

extension View {
    func eraseToAnyView() -> AnyView { AnyView(self) }
}
