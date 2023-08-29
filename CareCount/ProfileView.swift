//
//  ProfileView.swift
//  CareCount
//
//  Created by Jasmine Zhang on 8/28/23.
//

import SwiftUI

struct ProfileView: View {
    @State private var isEditingProfile = false
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
                                
                Text("Pixel")
                    .font(.system(size: 50))
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("darkPink"))
                    .padding(.top, 15)
                                
                Text("pixel.the.cat@example.com")
                    .font(.system(size: 20))
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .padding(.top, 5)
                            
                Spacer()
                                
                Button(action: {
                    isEditingProfile = true
                }) {
                    HStack {
                        Image(systemName: "pencil")
                        Text("Edit Profile")
                    }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 150)
                        .padding()
                        .background(Color("darkPink"))
                        .cornerRadius(10)
                }
            }
            .padding()
            .padding(.bottom, 30)
            .fullScreenCover(isPresented: $isEditingProfile) {
                EditProfileView(isPresented: $isEditingProfile)
            }
        }
    }
}

struct EditProfileView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        // Design your editing interface here
        Text("Edit Profile")
            .font(.title)
            .padding()
        
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
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
