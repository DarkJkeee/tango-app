//
//  RegistrationView.swift
//  Tango
//
//  Created by Глеб Бурштейн on 01.11.2020.
//

import SwiftUI

struct RegistrationView: View {
    @ObservedObject var sessionVM = SessionViewModel()
    
    var body: some View {
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
                    TextField("Username", text: $sessionVM.username)
                        .autocapitalization(.none)
                }
                .padding()
                .cornerRadius(20)
                
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(Color.orange)
                    TextField("Email", text: $sessionVM.email)
                        .autocapitalization(.none)
                }
                .padding()
                .cornerRadius(20)
                
                HStack {
                    Image(systemName: "eye.slash.fill")
                        .foregroundColor(Color.orange)
                    SecureField("Password", text: $sessionVM.password)
                        .autocapitalization(.none)
                }
                .padding()
                .cornerRadius(20)
                
                HStack {
                    Image(systemName: "eye.slash.fill")
                        .foregroundColor(Color.orange)
                    SecureField("Repeat password", text: $sessionVM.passwordAgain)
                        .autocapitalization(.none)
                }
                .padding()
                .cornerRadius(20)
                
            }.padding([.leading, .trailing], 27.5)
            
            Spacer()
            
            NavigationLink(
                destination: TabbedPageView(),
                label: {
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 60)
                        .overlay(
                            Text("Sign Up")
                                .bold()
                                .foregroundColor(.white)
                        )
                        .foregroundColor(sessionVM.isValid ? .orange : .gray)
                    
                })
                .padding()
                .disabled(!sessionVM.isValid)
            
            Spacer()
        }
        
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
            .preferredColorScheme(.light)
    }
}
