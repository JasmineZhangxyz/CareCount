//
//  ProfileView.swift
//  CareCount
//
//  Created by Jasmine Zhang on 8/28/23.
//

import SwiftUI

struct ProfileView: View {
    // for database
    @StateObject private var dataManager = DataManager()
    
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
                                
                // HARDCODED: displays profile with id = 1
                if let profile = dataManager.profiles.first(where: { $0.id == 1 }) {
                    Text(profile.username)
                        .font(.system(size: 45, weight: .bold, design: .rounded))
                        .foregroundColor(Color("darkPink"))
                        .padding(.top, 15)
                    
                    Text(profile.email)
                        .font(.system(size: 24, design: .rounded))
                        .foregroundColor(Color("darkGray"))
                        .padding(.top, 3)
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
                    .frame(width: 150)
                    .padding()
                    .background(Color("darkPink"))
                    .cornerRadius(10)
                }
            }
            .padding()
            .fullScreenCover(isPresented: $isEditingProfile) {
                // HARDCODED
                EditProfileView(isPresented: $isEditingProfile, profile: dataManager.profiles.first(where: { $0.id == 1 })!)
            }
        }
    }
}

struct EditProfileView: View {
    @Binding var isPresented: Bool
    
    // holds profile being edited
    @State private var editedProfile: UserProfile

    // initialize with the edited profile
    init(isPresented: Binding<Bool>, profile: UserProfile) {
        _isPresented = isPresented
        _editedProfile = State(initialValue: profile)
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
                    TextField("", text: $editedProfile.username)
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
                
                Button(action: {
                    // Perform profile update logic here
                    
                    // Dismiss the editing view
                    isPresented = false
                }) {
                    Text("Save Changes")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color("darkPink"))
                        .cornerRadius(10)
                }
                .padding()
                .padding(.vertical, 30)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
