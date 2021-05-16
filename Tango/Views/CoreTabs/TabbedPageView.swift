//
//  TabbedPageView.swift
//  Tango
//
//  Created by Глеб Бурштейн on 01.11.2020.
//

import SwiftUI

struct TabbedPageView: View {
    @StateObject var profileVM = ProfileViewModel(id: Session.shared.userId)
    
    var body: some View {
        NavigationView {
            TabBar()
                .navigationBarHidden(true)
                .navigationViewStyle(StackNavigationViewStyle())
        }
        .environmentObject(profileVM)
    }
}

struct TabBar: View {
    @State var selectedTab = "Home"
    @Namespace private var animation
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { _ in
                ZStack {
                    HomeView()
                        .opacity(selectedTab == "Home" ? 1 : 0)
                    ChatListView()
                        .opacity(selectedTab == "Chat" ? 1 : 0)
                    ProfileView()
                        .opacity(selectedTab == "Profile" ? 1 : 0)
                }
            }
            
            HStack {
                TabButton(title: "Home", image: "house.fill", selectedTab: $selectedTab, animation: animation)
                Spacer()
                TabButton(title: "Chat", image: "message", selectedTab: $selectedTab, animation: animation)
                Spacer()
                TabButton(title: "Profile", image: "person.fill", selectedTab: $selectedTab, animation: animation)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom == 0 ? 15 : 20)
            .background(colorScheme == .dark ? Color.backgroundColorDark: Color.backgroundColorLight)
        }
        .background(colorScheme == .dark ? Color.backgroundColorDark: Color.backgroundColorLight)
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

struct TabButton: View {
    @Environment(\.colorScheme) var colorScheme
    
    var title: String
    var image: String
    
    @Binding var selectedTab: String
    var animation: Namespace.ID
    
    var body: some View {
        Button(action: {
            withAnimation {
                selectedTab = title
            }
        }, label: {
            VStack(spacing: 6) {
                ZStack {
                    CustomShape()
                        .fill(Color.clear)
                        .frame(width: 45, height: 6)
                    
                    if selectedTab == title {
                        CustomShape()
                            .fill(colorScheme == .dark ? Color.AccentColorLight : Color.AccentColorDark)
                            .frame(width: 45, height: 3)
                            .matchedGeometryEffect(id: "ID", in: animation)
                    }
                }
                
                Image(systemName: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(selectedTab == title ? colorScheme == .dark ? Color.AccentColorLight : Color.AccentColorDark : colorScheme == .dark ? Color.AccentColorLight.opacity(0.4) : Color.AccentColorDark.opacity(0.4))
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.custom("Dosis-Regular", size: 16))
                    .fontWeight(.bold)
                    .opacity(selectedTab == title ? 1 : 0.4)
            }
        })
    }
}

struct CustomShape: Shape {
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 10, height: 10))
        return Path(path.cgPath)
    }
}

struct TabbedPageView_Previews: PreviewProvider {
    static var previews: some View {
        TabbedPageView()
            .preferredColorScheme(.light)
    }
}
