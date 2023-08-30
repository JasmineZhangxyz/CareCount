//
//  SignUpView.swift
//  CareCount
//
//  Created by Si Yeun Lee on 2023-08-28.
//

import SwiftUI
import Firebase

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var username: String = ""
    @State private var signUpSuccessful: Bool = false
    @State private var errorMessage: String = ""
    
    @EnvironmentObject var authenticationManager: AuthenticationManager
    
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
                
                VStack(alignment: .leading) {
                    TextField("Email", text: $email)
                    
                    SecureField("Password", text: $password)
                    
                    TextField("Username", text: $username)
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 40)
                .cornerRadius(8)
                .font(.system(size: 14, design: .rounded))
                .autocapitalization(.none)
                
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
                .disabled(email.isEmpty || password.isEmpty || username.isEmpty)
                .opacity((email.isEmpty || password.isEmpty || username.isEmpty) ? 0.7 : 1.0)
                
                // display error message, if any
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.system(size: 14, design: .rounded))
                    .padding()
            }
        }
    }
    
    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else if let authResult = authResult {
                let db = Firestore.firestore()
                let profileData = ["email": email, "username": username] as [String: Any]
                
                // Let Firestore generate a unique ID for the document
                db.collection("UserProfiles").addDocument(data: profileData) { error in
                    if let error = error {
                        print("Error saving user profile data: \(error.localizedDescription)")
                    } else {
                        print("User profile data saved successfully")
                        authenticationManager.isUserAuthenticated = true
                        authenticationManager.userId = authResult.user.uid
                        signUpSuccessful = true
                    }
                }
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
