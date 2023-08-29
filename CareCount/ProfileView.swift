//
//  ProfileView.swift
//  CareCount
//
//  Created by Jasmine Zhang on 8/28/23.
//

import SwiftUI

struct ProfileView: View {
    @State private var tabSelected: Tab = .profile
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack {
            Color("backgroundPink")
                .ignoresSafeArea()
            VStack {
                Text("Profile")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("darkPink"))
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
