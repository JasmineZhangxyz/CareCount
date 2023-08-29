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
                    // page
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
                    // footer
                    Spacer()
                    FooterView(selectedTab: $selectedTab)
                }
                .navigationBarHidden(true) // hide the navigation bar
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
                // formatting for footer icons
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Spacer()
                    // changes clicked icon to pink + larger
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
            // formatting for footer
            .frame(width: nil, height: 60)
            .background(.thinMaterial)
            .cornerRadius(20)
            .padding()
        }
    }
    // routing
    func getDestinationView(tab: Tab) -> AnyView {
        switch tab {
        case .house:
            return AnyView(HomeView())
        case .routine:
            return AnyView(RoutineView())
        case .todo:
            return AnyView(ToDoView())
        case .profile:
            return AnyView(ProfileView())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
