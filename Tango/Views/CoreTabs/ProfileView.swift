//
//  ProfileView.swift
//  Tango
//
//  Created by Глеб Бурштейн on 05.02.2021.
//

import SwiftUI

struct ProfileView: View {
    @State var isShowingSettings = false
    let profileLinkNames = ["Favourite movies", "Followers", "Following"]
    
    var body: some View {
        VStack {
            topbar
            content
        }
        .background(Color.BackgroundColor)
        .sheet(isPresented: $isShowingSettings, content: {
            SettingsPage()
        })
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
    }
    
    private var topbar: some View {
        HStack {
            Text("Profile")
                .font(.custom("Dosis-Bold", size: 40))
                .foregroundColor(Color.AccentColor)
                .padding(.leading, 20)
            Spacer()
            
            Button(action: {
                isShowingSettings.toggle()
            }, label: {
                Image(systemName: "gear")
                    .resizable()
                    .foregroundColor(Color.AccentColor)
                    .frame(width: 30, height: 30)
                    .padding(.trailing, 20)
            })
        }
        .padding(.top, UIScreen.main.bounds.height * 0.05)
        .padding(.bottom, 1)
    }
    
    private var content: some View {
        VStack(spacing: 0) {
            ForEach(profileLinkNames, id: \.self) { profileLinkName in
                NavigationLink(destination: Text("")) {
                    VStack {
                        HStack {
//                            Image(systemName: "favorite")
                            Text(profileLinkName)
                                .font(.custom("Dosis-Regular", size: 24))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color(.systemGray3))
                                .font(.system(size: 20))
                        }
                        .padding(EdgeInsets(top: 17, leading: 21, bottom: 17, trailing: 21))
                        Divider()
                    }
                }
            }
            Spacer()
            
            Button(action: {
                
            }, label: {
                HStack {
                    Image(systemName: "arrowshape.turn.up.left")
                        .resizable()
                        .foregroundColor(Color.AccentColor)
                        .frame(width: 30, height: 30)
                    Text("Logout")
                        .font(.custom("Dosis-Bold", size: 30))
                }
            })
            .padding()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
