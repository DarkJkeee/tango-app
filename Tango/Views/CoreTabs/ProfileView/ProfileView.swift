//
//  ProfileView.swift
//  Tango
//
//  Created by Глеб Бурштейн on 05.02.2021.
//

import SwiftUI

struct ProfileView: View {
    let profileLinkNames: [String] = ["Favourite movies", "Followers", "Following"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ForEach(profileLinkNames, id: \.self) { profileLinkName in
                    NavigationLink(destination: Text("")) {
                        VStack { // Embed both the HStack and Divider in a VStack
                            HStack {
                                Text(profileLinkName)
                                    .font(.body)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color(.systemGray3))
                                    .font(.system(size: 20))
                            }
                            .padding(EdgeInsets(top: 17, leading: 21, bottom: 17, trailing: 21))
                            Divider() // Add a divider
                        }
                    }
                }
                Spacer()
            }
            .navigationBarTitle("Profile")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
