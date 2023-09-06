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
                if let errorDescription = error?.localizedDescription {
                    print(errorDescription)
                } else {
                    print("Unknown error occurred")
                }
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
                if let errorDescription = error?.localizedDescription {
                    print(errorDescription)
                } else {
                    print("Unknown error occurred")
                }
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let uid = data["uid"] as? String ?? ""
                    let id = data["id"] as? String ?? ""
                    let name = data["name"] as? String ?? ""
                    let mon = data["mon"] as? Bool ?? false
                    let tue = data["tue"] as? Bool ?? false
                    let wed = data["wed"] as? Bool ?? false
                    let thu = data["thu"] as? Bool ?? false
                    let fri = data["fri"] as? Bool ?? false
                    let sat = data["sat"] as? Bool ?? false
                    let sun = data["sun"] as? Bool ?? false
                    
                    let routine = Routine(uid: uid, id: id, name: name, mon: mon, tue: tue, wed: wed, thu: thu, fri: fri, sat: sat, sun: sun)
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
    
    func addRoutine(_ routine: Routine) {
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        
        ref = db.collection("Routines").addDocument(data: [
            "uid": routine.uid,
            "id": routine.id,
            "name": routine.name,
            "mon": routine.mon,
            "tue": routine.tue,
            "wed": routine.wed,
            "thu": routine.thu,
            "fri": routine.fri,
            "sat": routine.sat,
            "sun": routine.sun
        ]) { error in
            if let error = error {
                print("Error adding routine: \(error.localizedDescription)")
            } else {
                print("Routine added with ID: \(ref!.documentID)")
            }
        }
    }

    func updateRoutine(_ routine: Routine) {
        let db = Firestore.firestore()
        let routineRef = db.collection("Routines").document(routine.id)
        
        routineRef.updateData([
            "name": routine.name,
            "mon": routine.mon,
            "tue": routine.tue,
            "wed": routine.wed,
            "thu": routine.thu,
            "fri": routine.fri,
            "sat": routine.sat,
            "sun": routine.sun
        ]) { error in
            if let error = error {
                print("Error updating routine: \(error.localizedDescription)")
            } else {
                print("Routine updated successfully.")
            }
        }
    }
    
    func deleteRoutine(forUserID userId: String, withRoutineName routineName: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let routinesRef = db.collection("Routines")
        
        routinesRef.whereField("id", isEqualTo: userId)
            .whereField("name", isEqualTo: routineName)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error getting documents: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No matching documents.")
                    completion(false)
                    return
                }
                
                for document in documents {
                    let routineId = document.documentID
                    let routineRef = routinesRef.document(routineId)
                    
                    routineRef.delete { error in
                        if let error = error {
                            print("Error deleting routine: \(error.localizedDescription)")
                            completion(false)
                        } else {
                            print("Routine deleted successfully from Firebase.")
                            completion(true)
                        }
                    }
                }
            }
    }
}
