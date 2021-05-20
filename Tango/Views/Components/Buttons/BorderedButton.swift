//
//  BorderedButton.swift
//  Tango
//
//  Created by Глеб Бурштейн on 11.03.2021.
//

import SwiftUI

public struct BorderedButton : View {
    @Environment(\.colorScheme) var colorScheme
    public let text: String
    public var systemImageName: String?
    public let color: Color
    public let isOn: Bool
    public var width: CGFloat?
    public var height: CGFloat?
    public let action: () -> Void
    
    public var body: some View {
        Button(action: {
            self.action()
        }, label: {
            HStack(alignment: .center, spacing: 4) {
                if systemImageName != nil {
                    Image(systemName: systemImageName!)
                }
                Text(text)
            }
            .frame(width: width, height: height)
            .foregroundColor(isOn ? colorScheme == .dark ? .AccentColorDark : .AccentColorLight : color)
            })
            .buttonStyle(BorderlessButtonStyle())
            .padding(6)
            .background(RoundedRectangle(cornerRadius: 8)
            .stroke(color, lineWidth: isOn ? 0 : 2)
            .background(isOn ? color : .clear)
            .cornerRadius(8))
    }
}
