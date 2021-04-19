//
//  SettingsPage.swift
//  Tango
//
//  Created by Глеб Бурштейн on 19.04.2021.
//

import SwiftUI

struct SettingsPage: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        ZStack {
            Color.red.edgesIgnoringSafeArea(.all)
            List {
                Section(header: Text("Profile").font(.custom("Dosis-Regular", size: 20))) {
                    Button(action: {
                        
                    }, label: {
                        SettingsCell(imageName: "person.fill", title: "Username")
                    })
                    
                }
                .padding()
                
                Section(header: Text("Themes").font(.custom("Dosis-Regular", size: 20))) {
                    Picker("Mode", selection: $isDarkMode) {
                        Text("Light")
                            .tag(false)
                        Text("Dark")
                            .tag(true)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding()
            }
            .background(Color("Background"))
            .listStyle(InsetGroupedListStyle())
        }
    }
    
}

struct SettingsCell: View {
    var imageName: String
    var title: String
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
            
            Text(title)
                .font(.custom("Dosis-Regular", size: 20))
            
            Spacer()
            
            Image(systemName: "chevron.right")
        }
    }
}

struct SettingsPage_Previews: PreviewProvider {
    static var previews: some View {
        SettingsPage()
            .preferredColorScheme(.dark)
    }
}
