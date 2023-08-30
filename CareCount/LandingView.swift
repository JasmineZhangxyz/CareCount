//
//  LandingView.swift
//  CareCount
//
//  Created by Jasmine Zhang on 8/28/23.
//

import SwiftUI

struct LandingView: View {
    
    @EnvironmentObject var authenticationManager: AuthenticationManager
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("backgroundPink")
                    .ignoresSafeArea()
                VStack(spacing: -10) {
                    Image("Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding([.leading, .bottom, .trailing])
                        .padding(.top, -50)
                    HStack(spacing: 15) {
                        NavigationLink(destination: SignInView()) {
                            Text("Sign In")
                                .frame(maxWidth: .infinity)
                        }.buttonStyle(CustomButtonStyle())
                        NavigationLink(destination: SignUpView()) {
                            Text("Sign Up")
                                .frame(maxWidth: .infinity)
                        }.buttonStyle(CustomButtonStyle())
                    }
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .padding(.horizontal, 40)
                }
            }
        }
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}

