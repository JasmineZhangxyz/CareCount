//
//  ContentView.swift
//  CareCount
//
//  Created by Jasmine Zhang on 8/28/23.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case house = "house"
    case routine = "list.bullet.clipboard"
    case todo = "checkmark.square"
    case profile = "person"
}

struct ContentView: View {
    @State private var selectedTab: Tab = .house
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("backgroundPink")
                    .ignoresSafeArea()
                VStack {
                    // Content based on selected tab
                    switch selectedTab {
                    case .house:
                        HomeView()
                    case .routine:
                        RoutineView()
                    case .todo:
                        ToDoView()
                    case .profile:
                        ProfileView()
                    }
                    
                    Spacer()
                    
                    // Footer navigation
                    FooterView(selectedTab: $selectedTab)
                }
                .navigationBarHidden(true) // Hide the navigation bar
            }
        }
    }
}

struct FooterView: View {
    @Binding var selectedTab: Tab
    private var fillImage: String {
        selectedTab.rawValue + ".fill"
    }
    
    var body: some View {
        VStack {
            HStack {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Spacer()
                    Image(systemName: selectedTab == tab ? fillImage : tab.rawValue)
                        .scaleEffect(tab == selectedTab ? 1.25 : 1.0)
                        .foregroundColor(selectedTab == tab ? Color("darkPink") : .black)
                        .font(.system(size: 20))
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.1)) {
                                selectedTab = tab
                            }
                        }
                    Spacer()
                }
            }
            .frame(width: nil, height: 60)
            .background(.thinMaterial)
            .cornerRadius(20)
            .padding()
        }
    }
    
    func getDestinationView(tab: Tab) -> AnyView {
        switch tab {
        case .house:
            return AnyView(HomeView()) // Placeholder, not used here
        case .routine:
            return AnyView(RoutineView()) // Placeholder, not used here
        case .todo:
            return AnyView(ToDoView()) // Placeholder, not used here
        case .profile:
            return AnyView(ProfileView()) // Placeholder, not used here
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
