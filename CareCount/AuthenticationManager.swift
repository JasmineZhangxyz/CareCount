//
//  AuthenticationManager.swift
//  CareCount
//
//  Created by Jasmine Zhang on 8/30/23.
//

import FirebaseAuth
import Combine

class AuthenticationManager: ObservableObject {
    @Published var isUserAuthenticated: Bool = false
    var userId: String?
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        // Listen for changes in the user's authentication state
        Auth.auth().addStateDidChangeListener { auth, user in
            self.isUserAuthenticated = user != nil
            self.userId = user?.uid
        }
    }
    
    // Add sign out functionality
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

