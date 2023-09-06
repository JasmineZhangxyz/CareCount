//
//  ProfileView.swift
//  CareCount
//
//  Created by Jasmine Zhang on 8/28/23.
//

import SwiftUI
import Firebase

struct ProfileView: View {
    // for database
    @EnvironmentObject var authenticationManager: AuthenticationManager
    @EnvironmentObject var dataManager: DataManager
    
    // for edit profile button
    @State private var isEditingProfile = false
    
    // for navbar
    @State private var tabSelected: Tab = .profile
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack {
            Color("backgroundPink")
                .ignoresSafeArea()
            VStack {
                Image(systemName: "heart.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(Color("darkPink"))
                    .padding(.top, 100)
                
                if let userId = authenticationManager.userId {
                    // Text("UserID: \(userId)") // Debug line
                                    
                    if let profile = dataManager.profiles.first(where: { $0.id == userId }) {
                        Text(profile.username)
                            .font(.system(size: 45, weight: .bold, design: .rounded))
                            .foregroundColor(Color("darkPink"))
                            .padding(.top, 30)
                                        
                        Text(profile.email)
                            .font(.system(size: 24, design: .rounded))
                            .foregroundColor(Color("darkGray"))
                            .padding(.top, 1)
                    }
                }
                            
                Spacer()
                
                Button(action: {
                    isEditingProfile = true
                }) {
                    HStack {
                        Image(systemName: "pencil")
                        Text("Edit Profile")
                    }
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(width: 300)
                    .padding()
                    .background(Color("darkPink"))
                    .cornerRadius(10)
                }
                
                Button(action: {
                    authenticationManager.signOut() // Call the signOut() method
                }) {
                    Text("Log Out")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(width: 300)
                        .padding()
                        .background(Color("darkGray"))
                        .cornerRadius(10)
                }
            }
            .padding()
            .fullScreenCover(isPresented: $isEditingProfile) {
                if let user = dataManager.profiles.first(where: { $0.id == authenticationManager.userId }) {
                    EditProfileView(
                        isPresented: $isEditingProfile,
                        profile: user,
                        dataManager: dataManager
                    )
                }
            }
        }
    }
}

struct EditProfileView: View {
    @Binding var isPresented: Bool
    @State private var editedProfile: UserProfile
    @State private var editedUsername = ""
    
    let dataManager: DataManager

    // initialize with the edited profile
    init(isPresented: Binding<Bool>, profile: UserProfile, dataManager: DataManager) {
        _isPresented = isPresented
        self.dataManager = dataManager
        _editedProfile = State(initialValue: profile)
        _editedUsername = State(initialValue: profile.username)
    }
    
    var body: some View {
        ZStack {
            Color("popupPink")
                .ignoresSafeArea()
            VStack {
                Text("Edit Profile")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("darkPink"))
                    .padding(.horizontal)
                    .padding(.top)
                
                // username - can be edited by user
                HStack {
                    Text("Username: ")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .padding(.leading, 15)
                    TextField("", text: $editedUsername)
                        .font(.system(size: 18, design: .rounded))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "pencil.tip.crop.circle")
                        .font(Font.system(size: 28))
                        .padding(.trailing)
                        .foregroundColor(Color("darkPink"))
                }
                .padding(.vertical)
                .frame(width: 350)
                .foregroundColor(.black)
                .background(Color.white)
                .cornerRadius(10)
                
                // email - cannot be edited by user
                HStack {
                    Text("Email: ")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .padding(.leading, 15)
                    Text(editedProfile.email)
                        .padding(.leading, 41) // gets the username + email to vertically align
                        .font(.system(size: 18, design: .rounded))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical)
                .frame(width: 350)
                .foregroundColor(.black)
                .background(Color.white)
                .cornerRadius(10)
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        // Update the username in DataManager and Firestore
                        dataManager.updateProfileUsername(id: editedProfile.id, newUsername: editedUsername)
                        isPresented = false
                    }) {
                        Text("Save Changes")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("darkPink"))
                            .cornerRadius(10)
                    }
                    .disabled(editedUsername.isEmpty)
                    .opacity((editedUsername.isEmpty) ? 0.7 : 1.0)
                    
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("Cancel")
                            .foregroundColor(Color("darkPink"))
                            .padding()
                            .background(Color.clear)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("darkPink"), lineWidth: 2)
                            )
                    }
                }
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .frame(width: 350)
                .padding(.horizontal)
                .padding(.vertical, 30)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        // Create instances of AuthenticationManager and DataManager
        let authManager = AuthenticationManager()
        let dataManager = DataManager(authManager: authManager)

        // Pass them as environment objects to RoutineView
        return ProfileView()
            .environmentObject(authManager)
            .environmentObject(dataManager)
    }
}
