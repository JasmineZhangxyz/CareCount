//
//  UserProfiles.swift
//  CareCount
//
//  Created by Jasmine Zhang on 8/30/23.
//

import SwiftUI

struct UserProfile: Identifiable {
    var id: String
    var email: String
    var username: String
}

struct Routine: Identifiable, Equatable {
    var id: String      // profile routine belongs to
    var name: String
    var mon: Bool
    var tue: Bool
    var wed: Bool
    var thu: Bool
    var fri: Bool
    var sat: Bool
    var sun: Bool
}
