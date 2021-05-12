//
//  ProfilePage.swift
//  Tango
//
//  Created by Глеб Бурштейн on 09.05.2021.
//

import SwiftUI
import Kingfisher

struct ProfilePage: View {
    var id: Int
    let profileLinkNames = ["Favourite movies", "Followers", "Following"]
    @EnvironmentObject var profileVM: ProfileViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                KFImage(URL(string: ""))
                    .placeholder({ Image("avatar") })
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
            }
            
            HStack {
                Text(profileVM.currentUser.username)
                    .font(.custom("Dosis-Bold", size: 24))
            }
            .padding()
            
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
        }
        .onAppear() {
            profileVM.loadProfileWith(id: id)
        }
    }
}

