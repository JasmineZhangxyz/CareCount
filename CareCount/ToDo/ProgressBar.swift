//
//  ProgressBar.swift
//  CareCount
//
//  Created by Jasmine Zhang on 8/28/23.
//

import SwiftUI

struct ProgressBar: View {
    var value: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: geometry.size.height / 2)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color.gray)
                
                RoundedRectangle(cornerRadius: geometry.size.height / 2)
                    .frame(width: min(CGFloat(self.value) * geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color("darkPink"))
            }
        }
    }
}
