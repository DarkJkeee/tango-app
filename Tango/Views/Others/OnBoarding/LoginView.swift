//
//  LoginView.swift
//  Tango
//
//  Created by Глеб Бурштейн on 01.11.2020.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            Text("Tangö")
            .font(.largeTitle)
            .padding([.top, .bottom], 40)
        
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(Color.orange)
                    TextField("Email", text: $email)
                }
                .padding()
                .background(Color(hue: 0.103, saturation: 0.0, brightness: 0.676))
                .cornerRadius(20)
        
                HStack {
                    Image(systemName: "eye.slash.fill")
                        .foregroundColor(Color.orange)
                    TextField("Email", text: $email)
                }
                .padding()
                .background(Color(hue: 0.103, saturation: 0.0, brightness: 0.676))
                .cornerRadius(20)
            }.padding([.leading, .trailing], 27.5)
        
            Button(action: {}) {
              Text("Sign In")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 300, height: 50)
                .background(Color.orange)
                .cornerRadius(15.0)
            }.padding()
        
            NavigationLink(
                destination: RegistrationView(),
                label: {
                    Text("Don't have an account? Sign up")
                        .foregroundColor(.black)
                        .opacity(0.4)
        
                })
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
