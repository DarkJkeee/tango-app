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
        VStack {
            topbar
            content
        }
        .background(Color("Background"))
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
    }
    
    private var topbar: some View {
        HStack {
            Text("Profile")
                .font(.custom("Dosis-Bold", size: 40))
                .foregroundColor(Color("Accent"))
                .padding(.leading, 20)
            Spacer()
            
            Button(action: {
                
            }, label: {
                Image(systemName: "arrow.up.and.person.rectangle.portrait")
                    .resizable()
                    .foregroundColor(Color("Accent"))
                    .frame(width: 30, height: 30)
                    .padding(.trailing, 20)
            })
        }
        .padding(.top, 40)
        .padding(.bottom, 5)
    }
    
    private var content: some View {
        VStack(spacing: 0) {
            ForEach(profileLinkNames, id: \.self) { profileLinkName in
                NavigationLink(destination: Text("")) {
                    VStack {
                        HStack {
                            Text(profileLinkName)
                                .font(.body)
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
