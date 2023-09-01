//
//  RoutineView.swift
//  CareCount
//
//  Created by Jasmine Zhang on 8/28/23.
//

import SwiftUI

struct RoutineView: View {
    // for database
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var dataManager: DataManager
    
    // for navbar
    @State private var tabSelected: Tab = .routine
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    @State private var isAddingTask = false
    @State private var tasks: [Task] = []
    @State private var newTaskName = ""
    @State private var selectedDays: Set<Day> = []
    @State private var oldTaskName = ""
    
    @State private var filteredRoutines: [Routine] = []
    
    var body: some View {
        ZStack {
            Color("backgroundPink")
                .ignoresSafeArea()
            VStack {
                Image("Heart")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 125, height: 125)
                    .padding(.top, 75)
                
                Text("Routine")
                    .font(.system(size: 45, weight: .bold, design: .rounded))
                    .foregroundColor(Color("darkPink"))
                
                // list of user's routines
                ScrollView {
                    VStack(spacing: -10) {
                        ForEach(filteredRoutines) { routine in
                            TaskButton(task: routineToTask(routine), action: {
                                editRoutine(routine)
                            })
                            .buttonStyle(ListItems())
                        }
                    }
                }
                
                // add button
                Button(action: { isAddingTask = true }) {
                    Text("+")
                        .font(.system(size: 32, design: .rounded))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .frame(width: 75)
                        .padding()
                        .foregroundColor(.black)
                        .background(Color.white)
                        .cornerRadius(25)
                }
                .padding()
                .fullScreenCover(isPresented: $isAddingTask) {
                    AddTaskView(isPresented: $isAddingTask, tasks: $tasks, newTaskName: $newTaskName, selectedDays: $selectedDays, oldTaskName: $oldTaskName)
                }
            }
        }
        .onAppear {
            guard let userId = authManager.userId else {
                return
            }
            dataManager.fetchRoutines() // Fetch all routines first
            filteredRoutines = dataManager.routines.filter { $0.id == userId }
            print("Fetching routines for user: \(authManager.userId ?? "Unknown User")")
            print("Filtered routines for user \(userId ): \(filteredRoutines.count)")
        }
        /*.onChange(of: dataManager.routines) { _ in
            let userId = authManager.userId
            filteredRoutines = dataManager.routines.filter { $0.id == userId }
        }*/
        .onChange(of: dataManager.routines) { newRoutines in
            let userId = authManager.userId
            filteredRoutines = newRoutines.filter { $0.id == userId }
                    
            print("Routines fetched: \(newRoutines.count)")
            print("Filtered routines for user \(userId ?? "Unknown User"): \(filteredRoutines.count)")
        }

    }

    func routineToTask(_ routine: Routine) -> Task {
        var selectedDays: Set<Day> = []
        if routine.mon { selectedDays.insert(.mon) }
        if routine.tue { selectedDays.insert(.tue) }
        if routine.wed { selectedDays.insert(.wed) }
        if routine.thu { selectedDays.insert(.thu) }
        if routine.fri { selectedDays.insert(.fri) }
        if routine.sat { selectedDays.insert(.sat) }
        if routine.sun { selectedDays.insert(.sun) }
        
        return Task(name: routine.name, selectedDays: selectedDays)
    }

    func editRoutine(_ routine: Routine) {
        var selectedRoutineDays: Set<Day> = []
        if routine.mon { selectedRoutineDays.insert(.mon) }
        if routine.tue { selectedRoutineDays.insert(.tue) }
        if routine.wed { selectedRoutineDays.insert(.wed) }
        if routine.thu { selectedRoutineDays.insert(.thu) }
        if routine.fri { selectedRoutineDays.insert(.fri) }
        if routine.sat { selectedRoutineDays.insert(.sat) }
        if routine.sun { selectedRoutineDays.insert(.sun) }
        
        newTaskName = routine.name
        oldTaskName = routine.name
        selectedDays = selectedRoutineDays
        isAddingTask = true
    }
}

struct TaskButton: View {
    let task: Task
    let action: () -> Void
    
    var body: some View {
        // clicking on a task lets you edit through AddTaskView
        Button(action: action) {
            HStack {
                Text(task.name)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                
                Spacer()
                
                Text(task.selectedDaysAbbreviated)
                    .font(.system(size: 14, design: .rounded))
                    .padding(.trailing)
            }
            .padding(.vertical)
            .foregroundColor(.black)
            .background(.white)
            .cornerRadius(10)
        }
    }
}

struct Task {
    var name: String
    var selectedDays: Set<Day>
    var selectedDaysAbbreviated: String {
        if selectedDays.count == Day.allCases.count {
            return "Daily"
        }
        else if selectedDays == Set([.mon, .tue, .wed, .thu, .fri]) {
            return "Weekdays"
        }
        else if selectedDays == Set([.sat, .sun]) {
            return "Weekends"
        }
        else {
            let sortedDays = Day.allCases.filter { selectedDays.contains($0) }
            return sortedDays.map { $0.rawValue }.joined(separator: " ")
        }
    }
}

struct RoutineView_Previews: PreviewProvider {
    static var previews: some View {
        RoutineView()
            .environmentObject(AuthenticationManager())
            .environmentObject(DataManager())
    }
}
