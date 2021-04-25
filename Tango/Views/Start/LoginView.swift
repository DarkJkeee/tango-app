//
//  LoginView.swift
//  Tango
//
//  Created by Глеб Бурштейн on 01.11.2020.
//

import SwiftUI
import Combine

struct LoginView: View {
    @State private var isShowing: Bool = false
    @State private var keyboardHeight: CGFloat = 0
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            Spacer()
            Text("Tangö")
                .font(.custom("Dosis-Bold", size: 50))
                .padding([.top, .bottom], 40)
            
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(Color.AccentColor)
                    TextField("Email", text: $email)
                }
                .padding()
                .cornerRadius(20)
                
                HStack {
                    Image(systemName: "eye.slash.fill")
                        .foregroundColor(Color.AccentColor)
                    SecureField("Password", text: $password)
                }
                .padding()
                .cornerRadius(20)
            }.padding([.leading, .trailing], 27.5)
            
            
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
                .foregroundColor(.orange)
                .padding()
            
            Spacer()
        }
        .padding(.bottom, keyboardHeight)
        .background(Color.BackgroundColor)
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
