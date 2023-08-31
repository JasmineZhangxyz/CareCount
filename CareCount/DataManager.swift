//
//  DataManager.swift
//  CareCount
//
//  Created by Jasmine Zhang on 8/30/23.
//

import Firebase

class DataManager: ObservableObject {
    @Published var profiles: [UserProfile] = []
    @Published var routines: [Routine] = []
    
    init() {
        fetchProfiles()
        fetchRoutines()
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
    
    func fetchRoutines() {
        routines.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Routines")
        
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let id = data["id"] as? String ?? ""
                    let name = data["name"] as? String ?? ""
                    let frequency = data["frequency"] as? String ?? ""
                    let mon = data["mon"] as? Bool ?? false
                    let tue = data["tue"] as? Bool ?? false
                    let wed = data["wed"] as? Bool ?? false
                    let thu = data["thu"] as? Bool ?? false
                    let fri = data["fri"] as? Bool ?? false
                    let sat = data["sat"] as? Bool ?? false
                    let sun = data["sun"] as? Bool ?? false
                    
                    let routine = Routine(id: id, name: name, frequency: frequency, mon: mon, tue: tue, wed: wed, thu: thu, fri: fri, sat: sat, sun: sun)
                    self.routines.append(routine)
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
