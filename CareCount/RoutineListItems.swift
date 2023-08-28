//
//  RoutineListItems.swift
//  CareCount
//
//  Created by Jasmine Zhang on 8/28/23.
//

import SwiftUI

struct RoutineListItems: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 30)
            .padding(.vertical)
            .foregroundColor(.black)
            .background(Color("white"))
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0) // Add a slight scale effect on press
    }
}
