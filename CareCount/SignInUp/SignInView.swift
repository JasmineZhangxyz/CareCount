//
//  SignInView.swift
//  CareCount
//
//  Created by Si Yeun Lee on 2023-08-28.
//

import SwiftUI
import Firebase

struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var signInSuccessful: Bool = false
    @State private var errorMessage: String = ""
    
    @EnvironmentObject var authenticationManager: AuthenticationManager
    
    var body: some View {
        if signInSuccessful {
            ContentView()
        } else {
            signInContent
        }
    }
    
    var signInContent: some View {
        ZStack {
            Color("backgroundPink")
                .ignoresSafeArea()
            VStack {
                Text("Sign In")
                    .font(.system(size: 45, weight: .bold, design: .rounded))
                    .foregroundColor(Color.white)
                    .padding(.vertical, 3)
                
                Text("Use your email to continue with CareCount")
                    .font(.system(size: 14, design: .rounded))
                    .padding(.bottom, 30)
                    .foregroundColor(Color("darkGray"))
                
                VStack(alignment: .leading) {
                    TextField("Email", text: $email)
                    
                    SecureField("Password", text: $password)
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 40)
                .cornerRadius(8)
                .font(.system(size: 14, design: .rounded))
                .autocapitalization(.none)
                
                Button(action: {
                    signIn()
                }) {
                    Text("Sign In")
                        .frame(maxWidth: .infinity, maxHeight: 2)
                        .font(.system(size: 18, design: .rounded))
                }
                .buttonStyle(CustomButtonStyle())
                .padding(.horizontal, 40)
                .padding(.top)
                .disabled(email.isEmpty || password.isEmpty)
                .opacity((email.isEmpty || password.isEmpty) ? 0.7 : 1.0)
                
                // display error message, if any
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.system(size: 14, design: .rounded))
                    .padding()
            }
        }
    }
    
    func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                authenticationManager.isUserAuthenticated = true
                authenticationManager.userId = authResult?.user.uid
                signInSuccessful = true
            }
        }
    }
}


struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
