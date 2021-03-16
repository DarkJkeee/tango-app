//
//  RegistrationView.swift
//  Tango
//
//  Created by Глеб Бурштейн on 01.11.2020.
//

import SwiftUI

struct RegistrationView: View {
    @State var username: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var checkerPass: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Tangö")
                    .font(.custom("Dosis-Bold", size: 50))
                    .padding([.top, .bottom], 20)
                Text("Create New Account")
                    .font(.custom("Dosis-Bold", size: 25))
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(Color.orange)
                        TextField("Username", text: $username)
                    }
                    .padding()
                    .cornerRadius(20)
                    
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(Color.orange)
                        TextField("Email", text: $email)
                    }
                    .padding()
                    .cornerRadius(20)
                    
                    HStack {
                        Image(systemName: "eye.slash.fill")
                            .foregroundColor(Color.orange)
                        SecureField("Password", text: $password)
                    }
                    .padding()
                    .cornerRadius(20)
                    
                    HStack {
                        Image(systemName: "eye.slash.fill")
                            .foregroundColor(Color.orange)
                        SecureField("Repeat password", text: $checkerPass)
                    }
                    .padding()
                    .cornerRadius(20)
                    
                }.padding([.leading, .trailing], 27.5)
                
                Spacer()
                
                Button(action: {
                    
                }) {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.orange)
                        .cornerRadius(15.0)
                }.padding()
                
                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
            .preferredColorScheme(.light)
    }
}
