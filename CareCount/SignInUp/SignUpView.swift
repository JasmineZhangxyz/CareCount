//
//  SignUpView.swift
//  CareCount
//
//  Created by Si Yeun Lee on 2023-08-28.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var signUpSuccessful: Bool = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        if signUpSuccessful {
            ContentView()
        } else {
            signUpContent
        }
    }
    
    var signUpContent: some View {
        ZStack {
            Color("backgroundPink")
                .ignoresSafeArea()
            VStack {
                Text("Sign Up")
                    .font(.system(size: 45, weight: .bold, design: .rounded))
                    .foregroundColor(Color.white)
                    .padding(.vertical, 3)
                
                Text("Create a free account with your email")
                    .font(.system(size: 14, design: .rounded))
                    .padding(.bottom, 30)
                    .foregroundColor(Color("darkGray"))
                
                AccountInfoText(email: $email, password: $password)
                
                Button(action: {
                    signUp()
                }) {
                    Text("Create your free account")
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
    
    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                signUpSuccessful = true
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
