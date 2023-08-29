//
//  ToDoView.swift
//  CareCount
//
//  Created by Jasmine Zhang on 8/28/23.
//

import SwiftUI

struct ToDoView: View {
    @State private var tabSelected: Tab = .todo
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack {
            Color("backgroundPink")
                .ignoresSafeArea()
            VStack {
                Text("To-Do List")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("darkPink"))
            }
        }
    }
}

struct ToDo_Previews: PreviewProvider {
    static var previews: some View {
        ToDoView()
    }
}
