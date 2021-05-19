//
//  RegistrationView.swift
//  Tango
//
//  Created by Глеб Бурштейн on 01.11.2020.
//

import SwiftUI
import Combine

struct RegistrationView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var sessionVM: SessionViewModel
    @StateObject var viewModel = RegistrationViewModel()
    
    @State private var keyboardHeight: CGFloat = 0
    
    var body: some View {
        ZStack {
            content
                .sheet(isPresented: $viewModel.isValid, content: {
                    verificationView
                })
            if viewModel.isLoading {
                LoadingScreen()
            }
        }
    }
    
    private var content: some View {
        VStack {
            Spacer()
            Text("Tangö")
                .font(.custom("Dosis-Bold", size: 50))
                .padding()
            
            if viewModel.isExist {
                Text("Username already exist!")
                    .foregroundColor(.red)
            }
            
            VStack(alignment: .leading, spacing: 15) {
                TextBar(text: $viewModel.username, placeholder: "Username", imageName: "person.fill", isSecureField: false)
                
                TextBar(text: $viewModel.email, placeholder: "Email", imageName: "envelope.fill", isSecureField: false)
                
                TextBar(text: $viewModel.password, placeholder: "Password", imageName: "eye.slash.fill", isSecureField: true)
                
                TextBar(text: $viewModel.passwordAgain, placeholder: "Repeat password", imageName: "eye.slash.fill", isSecureField: true)
                
            }
            .padding([.leading, .trailing], 27.5)

            Text(viewModel.usernameError)
                .foregroundColor(.red)
            Text(viewModel.passwordError)
                .foregroundColor(.red)
            
            AccentButton(title: "Sign Up", height: 60) {
                // TODO: Registration
                viewModel.register()
            }
            .foregroundColor(viewModel.isFormValid ? colorScheme == .dark ? .AccentLight: .AccentDark : .gray)
            .disabled(!viewModel.isFormValid)
            
            Spacer()
        }
        .padding(.bottom, keyboardHeight)
        .foregroundColor(colorScheme == .dark ? .AccentColorLight : .AccentColorDark)
        .background(colorScheme == .dark ? Color.backgroundColorDark : Color.backgroundColorLight)
        .edgesIgnoringSafeArea(.all)
        .onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
    }
    
    private var verificationView: some View {
        VStack {
            Text("You are succesfully registered.")
                .font(.custom("Dosis-Bold", size: 28))
                .padding()
            
            Text("You can login now in your account.")
                .font(.custom("Dosis-Regular", size: 24))
                .padding()
            
            Spacer()
            
            AccentButton(title: "Login", height: 60) {
                viewModel.isValid = false
                presentationMode.wrappedValue.dismiss()
            }
            .foregroundColor(colorScheme == .dark ? .AccentLight : .AccentDark)
            .padding()
            
            Spacer()
            
//            Image("email")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .padding()
            
            //                    HStack {
            //                        ForEach(0..<6, id: \.self) { index in
            //                            CodeView(code: "")
            //                        }
            //                    }
            //                    .padding()
            
            Spacer()
        }
        .foregroundColor(colorScheme == .dark ? .AccentColorLight : .AccentColorDark)
        .accentColor(colorScheme == .dark ? .AccentColorLight : .AccentColorDark)
        .background(colorScheme == .dark ? Color.backgroundColorDark : Color.backgroundColorLight)
    }
}

//struct CodeView: View {
//    var code: String
//    var body: some View {
//        VStack {
//            Text(code)
//                .foregroundColor(.black)
//                .fontWeight(.bold)
//                .font(.title2)
//                .frame(height: 45)
//
//            Capsule()
//                .fill(Color.gray.opacity(0.5))
//                .frame(height: 4)
//        }
//    }
//}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RegistrationView().previewDevice("iPhone 12 Pro Max")
                .preferredColorScheme(.dark)
            RegistrationView().previewDevice("iPhone SE (2nd generation)")
            RegistrationView().previewDevice("iPod touch (7th generation)")
        }
    }
}
