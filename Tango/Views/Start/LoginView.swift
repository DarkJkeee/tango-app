//
//  LoginView.swift
//  Tango
//
//  Created by Глеб Бурштейн on 01.11.2020.
//

import SwiftUI
import Combine

struct LoginView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var isShowing: Bool = false
    @State private var keyboardHeight: CGFloat = 0
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
//        ZStack {
            content
//            if loginVM.state == .logging {
//                Rectangle()
//                    .frame(width: 200, height: 100, alignment: .center)
//                    .foregroundColor(colorScheme == .dark ? Color.AccentColorDark : Color.AccentColorLight)
//                    .cornerRadius(10)
//                ProgressView("Loading...")
//            }
//        }
//        .alert(isPresented: $loginVM.isFailed) { () -> Alert in
//            Alert(title: Text("Invalid authorization data"), message: Text("Wrong email or password"), dismissButton: Alert.Button.default(Text("Okay")))
//        }
    }
    
    private var content: some View {
        VStack {
            Spacer()
            Text("Tangö")
                .font(.custom("Dosis-Bold", size: 50))
                .padding([.top, .bottom], 40)
            
            VStack(alignment: .leading, spacing: 15) {
                TextBar(text: $email, placeholder: "Email", imageName: "envelope.fill", isSecureField: false)
                
                TextBar(text: $password, placeholder: "Password", imageName: "eye.slash.fill", isSecureField: true)
            }
            .padding([.leading, .trailing], 27.5)
            .foregroundColor(colorScheme == .dark ? .AccentColorLight : .AccentColorDark)
            
            NavigationLink(
                destination: TabbedPageView(),
                isActive: $isShowing) {
                    Button(action: {
                        self.isShowing.toggle()
//                        loginVM.login()
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
                .foregroundColor(.orange)
                .padding()
            
            Spacer()
        }
        .padding(.bottom, keyboardHeight)
        .background(colorScheme == .dark ? Color.backgroundColorDark : Color.backgroundColorLight)
        .edgesIgnoringSafeArea(.all)
        .onReceive(Publishers.keyboardHeight) {
            self.keyboardHeight = $0
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .preferredColorScheme(.light)
    }
}
