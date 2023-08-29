//
//  SignInView.swift
//  CareCount
//
//  Created by Si Yeun Lee on 2023-08-28.
//

import SwiftUI

struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        ZStack {
            Color("backgroundPink")
                .ignoresSafeArea()
            VStack {
                Text("Sign In")
                    .font(.system(size:45))
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .padding(.vertical, 3)
                
                Text("Use your email to continue with CareCount")
                    .font(.system(size:12))
                    .padding([.bottom], 30)
                    .foregroundColor(Color("darkGray"))
                
                AccountInfoText(email: $email, password: $password)
                
                NavigationLink(destination: ContentView()) {
                    Text("Sign In")
                        .frame(maxWidth: .infinity, maxHeight: 2)
                        .font(.system(size:14))
                }
                .buttonStyle(CustomButtonStyle())
                .padding(.horizontal, 40)
                
            }
        }
    }
}


struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
