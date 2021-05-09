//
//  ProfileView.swift
//  Tango
//
//  Created by Глеб Бурштейн on 05.02.2021.
//

import SwiftUI
import Kingfisher

struct ProfileView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var sessionVM: SessionViewModel
    @EnvironmentObject var profileVM: ProfileViewModel
    
    @State var avatar: UIImage?
    @State var isShowingSettings = false
    @State var isShowingImagePicker = false
    let profileLinkNames = ["Favourite movies", "Followers", "Following"]
    
    var body: some View {
        NavigationView {
            VStack {
                topbar
                ProfilePage()
                AccentButton(title: "Logout", height: 60) {
                    sessionVM.logout()
                }
                .foregroundColor(colorScheme == .dark ? Color("AccentLight") : Color("AccentDark"))
            }
            .background(colorScheme == .dark ? Color.backgroundColorDark : Color.backgroundColorLight)
            .sheet(isPresented: $isShowingSettings, content: {
                SettingsPage()
            })
            .edgesIgnoringSafeArea(.all)
            .navigationBarHidden(true)
        }
    }
    
    private var topbar: some View {
        HStack {
            Text("Profile")
                .font(.custom("Dosis-Bold", size: 40))
                .foregroundColor(colorScheme == .dark ? .AccentColorLight : .AccentColorDark)
                .padding(.leading, 20)
            Spacer()
            
            Button(action: {
                isShowingSettings.toggle()
            }, label: {
                Image(systemName: "gear")
                    .resizable()
                    .foregroundColor(colorScheme == .dark ? .AccentColorLight : .AccentColorDark)
                    .frame(width: 30, height: 30)
                    .padding(.trailing, 20)
            })
        }
        .padding(.top, UIScreen.main.bounds.height * 0.05)
        .padding(.bottom, 1)
    }
    
//    private var content: some View {
//        VStack(spacing: 0) {
//            ZStack {
//                KFImage(URL(string: ""))
//                    .placeholder({ Image("avatar") })
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 150, height: 150)
//                    .clipShape(Circle())
//            }
//            .onTapGesture {
//                isShowingImagePicker = true
//            }
//            
//            HStack {
//                Text("Username")
//                    .font(.custom("Dosis-Bold", size: 24))
//            }
//            .padding()
//            
//            ForEach(profileLinkNames, id: \.self) { profileLinkName in
//                NavigationLink(destination: Text("")) {
//                    VStack {
//                        HStack {
////                            Image(systemName: "favorite")
//                            Text(profileLinkName)
//                                .font(.custom("Dosis-Regular", size: 24))
//                            Spacer()
//                            Image(systemName: "chevron.right")
//                                .foregroundColor(Color(.systemGray3))
//                                .font(.system(size: 20))
//                        }
//                        .padding(EdgeInsets(top: 17, leading: 21, bottom: 17, trailing: 21))
//                        Divider()
//                    }
//                }
//            }
//            
//            Spacer()
//            
//            AccentButton(title: "Logout", height: 60) {
//                sessionVM.logout()
//            }
//            .foregroundColor(colorScheme == .dark ? Color("AccentLight") : Color("AccentDark"))
//        }
//        .sheet(isPresented: $isShowingImagePicker) {
////            ImagePicker(image: $avatar)
////            sessionVM.changeAvatar(avatar: avatar ?? nil)
//        }
//        .foregroundColor(colorScheme == .dark ? .AccentColorLight : .AccentColorDark)
//    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(SessionViewModel())
            .environmentObject(ProfileViewModel())
    }
}
