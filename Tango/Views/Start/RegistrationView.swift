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
    
    @ObservedObject var loginVM: LoginViewModel
    @StateObject var viewModel = RegistrationViewModel()
    
    @State private var isShowing: Bool = false
    @State private var keyboardHeight: CGFloat = 0
    
    var body: some View {
        content
            .sheet(isPresented: $isShowing, content: {
                verificationView
            })
    }
    
    private var content: some View {
        VStack {
            Spacer()
            Text("Tangö")
                .font(.custom("Dosis-Bold", size: 50))
            Text("Create New Account")
                .padding(.top, 10)
                .font(.custom("Dosis-Bold", size: 25))
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 15) {
                TextBar(text: $viewModel.username, placeholder: "Username", imageName: "person.fill", isSecureField: false)
                
                TextBar(text: $viewModel.email, placeholder: "Email", imageName: "envelope.fill", isSecureField: false)
                
                TextBar(text: $viewModel.password, placeholder: "Password", imageName: "eye.slash.fill", isSecureField: true)
                
                TextBar(text: $viewModel.passwordAgain, placeholder: "Repeat password", imageName: "eye.slash.fill", isSecureField: true)
                
            }
            .padding([.leading, .trailing], 27.5)
            .foregroundColor(colorScheme == .dark ? .AccentColorLight : .AccentColorDark)

            Text(viewModel.usernameError)
                .foregroundColor(.red)
            Text(viewModel.passwordError)
                .foregroundColor(.red)
            
            Button(action: {
                
                // todo: register...
                isShowing.toggle()
            }, label: {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 60)
                    .overlay(
                        Text("Sign Up")
                            .font(.custom("Dosis-Bold", size: 20))
                            .foregroundColor(.white)
                    )
            })
            .padding()
            .foregroundColor(viewModel.isValid ? .orange : .gray)
            .disabled(!viewModel.isValid)
            
            Spacer()
        }
        .padding(.bottom, keyboardHeight)
        .background(colorScheme == .dark ? Color.backgroundColorDark : Color.backgroundColorLight)
        .edgesIgnoringSafeArea(.all)
        .onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
    }
    
    private var verificationView: some View {
        VStack {
            Text("Continue with email")
                .font(.custom("Dosis-Bold", size: 28))
                .foregroundColor(colorScheme == .dark ? .AccentColorLight : .AccentColorDark)
                .padding()
            
            Text("You will get an email. Follow the link in the letter to register an account.")
                .font(.custom("Dosis-Regular", size: 24))
                .foregroundColor(colorScheme == .dark ? .AccentColorLight : .AccentColorDark)
                .padding()
            
            Spacer()
            
            Button(action: {
                isShowing.toggle()
                presentationMode.wrappedValue.dismiss()
            }, label: {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 60)
                    .overlay(
                        Text("Login")
                            .font(.custom("Dosis-Bold", size: 20))
                            .foregroundColor(.AccentColorLight)
                    )
            })
            .foregroundColor(.orange)
            .padding()
            
            Spacer()
            
            Image("email")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
            
            //                    HStack {
            //                        ForEach(0..<6, id: \.self) { index in
            //                            CodeView(code: "")
            //                        }
            //                    }
            //                    .padding()
            
            Spacer()
        }
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
            RegistrationView(loginVM: LoginViewModel()).previewDevice("iPhone 12 Pro Max")
                .preferredColorScheme(.dark)
            RegistrationView(loginVM: LoginViewModel()).previewDevice("iPhone SE (2nd generation)")
            RegistrationView(loginVM: LoginViewModel()).previewDevice("iPod touch (7th generation)")
        }
    }
}
