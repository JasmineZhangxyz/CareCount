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
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                // User creation successful, now generate a unique user ID
                let userId = generateUniqueUserID()
                
                let db = Firestore.firestore()
                let profileData = ["id": userId, "email": email, "username": username] as [String : Any]
                
                db.collection("UserProfiles").document(String(userId)).setData(profileData) { error in
                    if let error = error {
                        print("Error saving user profile data: \(error.localizedDescription)")
                    } else {
                        print("User profile data saved successfully")
                        signUpSuccessful = true
                    }
                }
            }
        }
    }
    
    func generateUniqueUserID() -> Int {
        // Fetch the last used user ID or start with 1
        let lastUsedUserID = UserDefaults.standard.integer(forKey: "lastUsedUserID")
        let newUserID = lastUsedUserID + 1
        
        // Update the last used user ID
        UserDefaults.standard.set(newUserID, forKey: "lastUsedUserID")
        
        return newUserID
    }

}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
