//
//  RegistrationView.swift
//  Tango
//
//  Created by Глеб Бурштейн on 01.11.2020.
//

import SwiftUI
import Combine

struct RegistrationView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isShowing: Bool = false
    @State private var keyboardHeight: CGFloat = 0
    
    @ObservedObject var viewModel = RegistrationViewModel()
    
    var body: some View {
        NavigationView {
            content
        }
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
            
            NavigationLink(
                destination: TabbedPageView(),
                isActive: $isShowing) {
                    Button(action: {
                        self.isShowing = true
                    }, label: {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 60)
                            .overlay(
                                Text("Sign Up")
                                    .font(.custom("Dosis-Bold", size: 20))
                                    .foregroundColor(.white)
                            )
                    })
                }
                .padding()
                .foregroundColor(viewModel.isValid ? .orange : .gray)
                .disabled(!viewModel.isValid)
            
            NavigationLink(
                destination: LoginView(),
                label: {
                    Text("Already have an account? Sign in")
                        .font(.custom("Dosis-Light", size: 18))
                        .foregroundColor(colorScheme == .dark ? .AccentColorLight : .AccentColorDark)
                        .opacity(0.7)
                })
            
            Spacer()
        }
        .padding(.bottom, keyboardHeight)
        .background(colorScheme == .dark ? Color.backgroundColorDark : Color.backgroundColorLight)
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
    }
}

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
