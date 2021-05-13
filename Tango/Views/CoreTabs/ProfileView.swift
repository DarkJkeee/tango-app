//
//  ProfileView.swift
//  Tango
//
//  Created by Глеб Бурштейн on 05.02.2021.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var sessionVM: SessionViewModel
    @EnvironmentObject var profileVM: ProfileViewModel
    
    @State var isShowingSettings = false
    let profileLinkNames = ["Favourite movies", "Followers", "Following"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    topbar
                    ProfilePage(user: profileVM.mainUser, isChangeable: true)
                    AccentButton(title: "Logout", height: 60) {
                        sessionVM.logout()
                    }
                    .foregroundColor(colorScheme == .dark ? .AccentLight : .AccentDark)
                }
            }
            .background(colorScheme == .dark ? Color.backgroundColorDark : Color.backgroundColorLight)
            .sheet(isPresented: $isShowingSettings, content: {
                SettingsPage(user: profileVM.mainUser)
            })
            .edgesIgnoringSafeArea(.all)
            .navigationBarHidden(true)
        }
    }
    
    private var topbar: some View {
        HStack {
            Text("Profile")
                .font(.custom("Dosis-Bold", size: 40))
                .padding(.leading, 20)
            Spacer()
            
            Button(action: {
                isShowingSettings.toggle()
            }, label: {
                Image(systemName: "gear")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding(.trailing, 20)
            })
        }
        .foregroundColor(colorScheme == .dark ? .AccentColorLight : .AccentColorDark)
        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(SessionViewModel())
            .environmentObject(ProfileViewModel(id: 3))
    }
}
