//
//  LoadingView.swift
//  CareCount
//
//  Created by Si Yeun Lee on 2023-09-03.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView() {
            Text("Please give us a meowment")
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundColor(Color("darkPink"))
        }
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("backgroundPink"))
            .controlSize(.large)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
