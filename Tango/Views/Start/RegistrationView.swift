//
//  RegistrationView.swift
//  Tango
//
//  Created by Глеб Бурштейн on 01.11.2020.
//

import SwiftUI

struct RegistrationView: View {
    @State var isShowing: Bool = false
    @ObservedObject var sessionVM = RegistrationViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Tangö")
                    .font(.custom("Dosis-Bold", size: 50))
                    .padding(.top, 50)
                Text("Create New Account")
                    .padding([.top, .bottom], 30)
                    .font(.custom("Dosis-Bold", size: 25))
                
                
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
                    isActive: $isShowing) {
                        Button(action: {
                            self.isShowing = true
                        }, label: {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 60)
                                .overlay(
                                    Text("Sign Up")
                                        .bold()
                                        .foregroundColor(.white)
                                )
                        })
                    }
                    .padding()
                    .foregroundColor(sessionVM.isValid ? .orange : .gray)
                    .disabled(!sessionVM.isValid)
                NavigationLink(
                    destination: LoginView(),
                    label: {
                        Text("Already have an account? Sign in")
                            .font(.custom("Dosis-Light", size: 18))
                            .foregroundColor(Color("Accent"))
                            .opacity(0.6)
                    })
                
                Spacer()
            }
            .background(Color("Background"))
            .edgesIgnoringSafeArea(.all)
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
