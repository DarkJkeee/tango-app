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
    @State var isShowingAlert = false
    
    var body: some View {
            ScrollView {
                VStack {
                    topbar
                    ProfilePage(user: profileVM.mainUser, isChangeable: true)
                    HStack {
                        BorderedButton(text: "Logout", color: colorScheme == .dark ? .AccentLight : .AccentDark, isOn: false) {
                            sessionVM.logout()
                        }
                        .frame(width: 200)
                        BorderedButton(text: "Delete user", color: .red, isOn: false) {
                            isShowingAlert = true
                        }
                        .frame(width: 200)
                    }
                    if profileVM.error == .delete {
                        Text("Error: couldn't delete account!")
                            .foregroundColor(.red)
                    }
                }
            }
            .background(colorScheme == .dark ? Color.backgroundColorDark : Color.backgroundColorLight)
            .sheet(isPresented: $isShowingSettings, content: {
                SettingsPage(user: profileVM.mainUser)
            })
            .alert(isPresented: $isShowingAlert, content: {
                Alert(title: Text("Are you sure?"), message: Text("You will not be able to recover your account"), primaryButton: .default(Text("Delete"), action: {
                    profileVM.deleteUser()
                }), secondaryButton: .cancel())
            })
            .onChange(of: profileVM.logout) { _ in
                sessionVM.logout()
            }
            .edgesIgnoringSafeArea(.all)
            .navigationBarHidden(true)
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
    }
}
