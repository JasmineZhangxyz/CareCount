//
//  LandingView.swift
//  CareCount
//
//  Created by Jasmine Zhang on 8/28/23.
//

import SwiftUI

struct LandingView: View {
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
                                .font(.system(size: 18))
                        }.buttonStyle(CustomButtonStyle())
                        NavigationLink(destination: SignUpView()) {
                            Text("Sign Up")
                                .frame(maxWidth: .infinity)
                                .font(.system(size: 18))
                        }.buttonStyle(CustomButtonStyle())
                    }.padding(.horizontal, 40)
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

