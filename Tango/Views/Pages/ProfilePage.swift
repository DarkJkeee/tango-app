//
//  ProfilePage.swift
//  Tango
//
//  Created by Глеб Бурштейн on 09.05.2021.
//

import SDWebImageSwiftUI
import SwiftUI

struct ProfilePage: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State var user: User
    var isChangeable: Bool
    
    @State var isShowingImagePicker = false
    
    @EnvironmentObject var profileVM: ProfileViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Button(action: {
                    if isChangeable {
                        isShowingImagePicker = true
                    }
                }, label: {
                    ZStack {
                        WebImage(url: URL(string: isChangeable ? profileVM.mainUser.avatar ?? "" : user.avatar ?? ""))
                            .placeholder(Image("avatar"))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                    }
                })
                
                VStack {
                    Text(isChangeable ? profileVM.mainUser.username : user.username)
                        .font(.custom("Dosis-Bold", size: 24))
                    Text(isChangeable ? profileVM.mainUser.email : "")
                        .font(.custom("Dosis-Bold", size: 24))
                }
                .padding()
                
                NavigationLink(destination:
                ScrollView {
                    VStack {
                        if isChangeable {
                            ForEach(profileVM.mainUser.favorite) { movie in
                                NavigationLink(destination: MoviePage(movie: movie).environmentObject(profileVM)) {
                                    MovieSearchCard(movie: movie)
                                }
                            }
                        } else {
                            ForEach(user.favorite) { movie in
                                MovieSearchCard(movie: movie)
                            }
                        }
                    }
                }) {
                    VStack {
                        HStack {
                            Text("Favourite movies")
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
                
                Spacer()
            }
        }
        .sheet(isPresented: $isShowingImagePicker, content: {
            ImagePicker(sourceType: .photoLibrary) { image in
                profileVM.changeAvatar(avatar: image)
            }
        })
        if profileVM.isLoading {
            LoadingScreen()
        }
    }
}

