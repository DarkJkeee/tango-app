//
//  RegistrationView.swift
//  Tango
//
//  Created by Глеб Бурштейн on 01.11.2020.
//

import SwiftUI

struct RegistrationView: View {
    @State var selection: Int?
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
            
            Text(sessionVM.inlineError)
                .foregroundColor(.red)
            
            
            NavigationLink(
                destination: TabbedPageView(),
                tag: 1,
                selection: $selection,
                label: {
                    Button(action: {
                        
                        self.selection = 1
                    }, label: {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 60)
                            .overlay(
                                Text("Sign Up")
                                    .bold()
                                    .foregroundColor(.white)
                            )
                    })
                })
                .padding()
                .foregroundColor(sessionVM.isValid ? .orange : .gray)
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
