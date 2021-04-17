//
//  LoginView.swift
//  Tango
//
//  Created by Глеб Бурштейн on 01.11.2020.
//

import SwiftUI

struct LoginView: View {
    @State var isShowing: Bool = false
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
            }.padding([.leading, .trailing], 27.5)
            
            
            NavigationLink(
                destination: TabbedPageView(),
                isActive: $isShowing) {
                Button(action: {
                    
                    self.isShowing = true
                }) {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.orange)
                        .cornerRadius(15.0)
                }.padding()
            }
            Spacer()
        }
        .background(Color("Background"))
        .edgesIgnoringSafeArea(.all)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .preferredColorScheme(.light)
    }
}
