//
//  SettingsPage.swift
//  Tango
//
//  Created by Глеб Бурштейн on 19.04.2021.
//

import SwiftUI

struct SettingsPage: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    //    init() {
    //       UITableView.appearance().separatorStyle = .none
    //       UITableViewCell.appearance().backgroundColor = UIColor(Color.BackgroundColor)
    //       UITableView.appearance().backgroundColor = UIColor(Color.BackgroundColor)
    //    }
    //
    
    
    var body: some View {
        VStack {
            Section(header: Text("Profile").font(.custom("Dosis-Bold", size: 20))) {
                Button(action: {
                    
                }, label: {
                    SettingsCell(imageName: "mail.stack", title: "Change Email")
                })
                Button(action: {
                    
                }, label: {
                    SettingsCell(imageName: "person", title: "Change Username")
                })
                Button(action: {
                    
                }, label: {
                    SettingsCell(imageName: "pencil", title: "Change Password")
                })
            }
            .padding()
            
            Section(header: Text("Themes").font(.custom("Dosis-Bold", size: 20))) {
                Picker("Mode", selection: $isDarkMode) {
                    Image(systemName: "sun.min")
                        .tag(false)
                    Image(systemName: "moon.fill")
                        .tag(true)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding()
            Spacer()
        }
        .background(Color.BackgroundColor)
        .edgesIgnoringSafeArea(.all)
    }
}

struct SettingsCell: View {
    var imageName: String
    var title: String
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .padding(.trailing, 5)
            
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

