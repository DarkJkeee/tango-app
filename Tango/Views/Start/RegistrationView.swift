//
//  RegistrationView.swift
//  Tango
//
//  Created by Глеб Бурштейн on 01.11.2020.
//

import SwiftUI

struct RegistrationView: View {
    @State var isShowing: Bool = false
    
    @ObservedObject var viewModel = RegistrationViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("Tangö")
                    .font(.custom("Dosis-Bold", size: 50))
                Text("Create New Account")
                    .padding(.top, 10)
                    .font(.custom("Dosis-Bold", size: 25))
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(Color("Accent"))
                        TextField("Username", text: $viewModel.username)
                            .autocapitalization(.none)
                    }
                    .padding()
                    .cornerRadius(20)
                    
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(Color("Accent"))
                        TextField("Email", text: $viewModel.email)
                            .autocapitalization(.none)
                    }
                    .padding()
                    .cornerRadius(20)
                    
                    HStack {
                        Image(systemName: "eye.slash.fill")
                            .foregroundColor(Color("Accent"))
                        SecureField("Password", text: $viewModel.password)
                            .autocapitalization(.none)
                    }
                    .padding()
                    .cornerRadius(20)
                    
                    HStack {
                        Image(systemName: "eye.slash.fill")
                            .foregroundColor(Color("Accent"))
                        SecureField("Repeat password", text: $viewModel.passwordAgain)
                            .autocapitalization(.none)
                    }
                    .padding()
                    .cornerRadius(20)
                    
                }.padding([.leading, .trailing], 27.5)

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
                                        .bold()
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
        Group {
            RegistrationView().previewDevice("iPhone 12 Pro Max")
                .preferredColorScheme(.dark)
            RegistrationView().previewDevice("iPhone SE (2nd generation)")
            RegistrationView().previewDevice("iPod touch (7th generation)")
        }
    }
}
