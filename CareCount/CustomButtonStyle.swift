//
//  CustomButtonStyle.swift
//  CareCount
//
//  Created by Jasmine Zhang on 8/28/23.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(.white)
            .background(Color("darkPink"))
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0) // Add a slight scale effect on press
    }
}
