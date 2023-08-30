//
//  AccountInfoText.swift
//  CareCount
//
//  Created by Si Yeun Lee on 2023-08-28.
//

import SwiftUI

struct AccountInfoText: View {
    @Binding var email: String
    @Binding var password: String
        
    var body: some View {
        VStack(alignment: .leading) {
            TextField("Email", text: $email)
            
            SecureField("Password", text:$password)
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding(.horizontal, 40)
        .cornerRadius(8)
        .font(.system(size: 14, design: .rounded))
        .autocapitalization(.none)
    }
}
