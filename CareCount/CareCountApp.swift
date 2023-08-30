//
//  CareCountApp.swift
//  CareCount
//
//  Created by Jasmine Zhang on 8/28/23.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct CareCountApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var dataManager = DataManager()
    @StateObject var authenticationManager = AuthenticationManager()
    
    var body: some Scene {
        WindowGroup {
            if authenticationManager.isUserAuthenticated {
                ContentView()
                    .environmentObject(dataManager)
                    .environmentObject(authenticationManager)
            } else {
                LandingView()
                // SignInView()
                    // .environmentObject(authenticationManager)
            }
        }
    }
}
