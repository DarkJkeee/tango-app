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
    
    @State private var keyboardHeight: CGFloat = 0
    @EnvironmentObject var sessionVM: SessionViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                content
                if sessionVM.state == .logging {
                    Rectangle()
                        .frame(width: 200, height: 100, alignment: .center)
                        .foregroundColor(colorScheme == .dark ? Color.AccentColorDark : Color.AccentColorLight)
                        .cornerRadius(10)
                    ProgressView("Loading...")
                }
            }
        }
    }
    
    private var content: some View {
        VStack {
            Spacer()
            Text("Tangö")
                .font(.custom("Dosis-Bold", size: 50))
                .padding([.top, .bottom], 40)
            
            Text(sessionVM.errorMsg)
                .foregroundColor(.red)
            
            VStack(alignment: .leading, spacing: 15) {
                TextBar(text: $sessionVM.email, placeholder: "Email", imageName: "envelope.fill", isSecureField: false)
                    .onChange(of: sessionVM.email) { _ in
                        sessionVM.errorMsg = ""
                    }
                
                TextBar(text: $sessionVM.password, placeholder: "Password", imageName: "eye.slash.fill", isSecureField: true)
            }
            .padding([.leading, .trailing], 27.5)
            
            AccentButton(title: "Login", height: 60) {
                sessionVM.login()
            }
            .foregroundColor(colorScheme == .dark ? .AccentLight : .AccentDark)
            
            NavigationLink(destination: Text("Hello")) {
                Text("Forget your password?")
                    .font(.custom("Dosis-Light", size: 18))
                    .foregroundColor(colorScheme == .dark ? .AccentLight : .AccentDark)
                    .opacity(0.7)
            }
            .padding()
            
            NavigationLink(destination: RegistrationView()) {
                Text("Don't have an account? Sign up")
                    .font(.custom("Dosis-Light", size: 18))
                    .opacity(0.7)
            }
            .padding()
            
            Spacer()
        }
        .padding(.bottom, keyboardHeight)
        .foregroundColor(colorScheme == .dark ? .AccentColorLight : .AccentColorDark)
        .background(colorScheme == .dark ? Color.backgroundColorDark : Color.backgroundColorLight)
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(SessionViewModel())
            .preferredColorScheme(.light)
    }
}
