//
//  ProfilePage.swift
//  Tango
//
//  Created by Глеб Бурштейн on 09.05.2021.
//

import SwiftUI
import Kingfisher

struct ProfilePage: View {
//    let user: User
    let profileLinkNames = ["Favourite movies", "Followers", "Following"]
    
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
                Text("Username")
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
    }
}

struct ProfilePage_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePage()
    }
}
