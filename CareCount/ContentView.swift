//
//  ContentView.swift
//  CareCount
//
//  Created by Jasmine Zhang on 8/28/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color("backgroundPink")
                    .ignoresSafeArea()
                VStack(spacing: -10) {
                    Image("Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.all)
                    HStack(spacing: 15) {
                        NavigationLink(destination: MainView()) {
                            Text("Sign In")
                                .frame(maxWidth: .infinity)
                        }.buttonStyle(CustomButtonStyle())
                        NavigationLink(destination: MainView()) {
                            Text("Sign Up")
                                .frame(maxWidth: .infinity)
                        }.buttonStyle(CustomButtonStyle())
                    }.padding(.horizontal, 40)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

