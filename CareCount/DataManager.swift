//
//  DataManager.swift
//  CareCount
//
//  Created by Jasmine Zhang on 8/30/23.
//

import Firebase

class DataManager: ObservableObject {
    @Published var profiles: [UserProfile] = []
    
    init() {
        fetchProfiles()
    }
    
    func fetchProfiles() {
        profiles.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("UserProfiles")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let id = data["id"] as? String ?? ""
                    let email = data["email"] as? String ?? ""
                    let username = data["username"] as? String ?? ""
                    
                    let profile = UserProfile(id: id, email: email, username: username)
                    self.profiles.append(profile)
                }
            }
        }
    }
    
    func updateProfileUsername(id: String, newUsername: String) {
            let db = Firestore.firestore()
            let ref = db.collection("UserProfiles").document(id)
            
            ref.updateData(["username": newUsername]) { error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    // Update the username in the local profiles array
                    if let index = self.profiles.firstIndex(where: { $0.id == id }) {
                        self.profiles[index].username = newUsername
                    }
                }
            }
        }
}
