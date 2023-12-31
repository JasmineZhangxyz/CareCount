//
//  RoutineView.swift
//  CareCount
//
//  Created by Jasmine Zhang on 8/28/23.
//

import SwiftUI
import Firebase

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
                        ForEach(dataManager.routines) { routine in
                            TaskButton(task: routineToTask(routine), action: {
                                editRoutine(routine)
                            })
                            .buttonStyle(ListItems())
                        }
                    }
                }
                .onAppear {
                    // Fetch or load the user's routines when the view appears
                    if let _ = authManager.userId {
                        // Access the userId from the authManager
                        let db = Firestore.firestore()
                        let routinesRef = db.collection("Routines")
                        dataManager.setupRoutinesListener(for: routinesRef)
                        
                        filteredRoutines = dataManager.filteredRoutines // Use the filteredRoutines property
                        print(filteredRoutines)
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
                        .background(.white)
                        .cornerRadius(25)
                }
                .padding()
                .fullScreenCover(isPresented: $isAddingTask) {
                    AddTaskView(
                        isPresented: $isAddingTask,
                        newTaskName: $newTaskName,
                        selectedDays: $selectedDays,
                        oldTaskName: $oldTaskName,
                        filteredRoutines: $filteredRoutines
                    )
                }
            }
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
        // Create instances of AuthenticationManager and DataManager
        let authManager = AuthenticationManager()
        let dataManager = DataManager(authManager: authManager)

        // Pass them as environment objects to RoutineView
        return RoutineView()
            .environmentObject(authManager)
            .environmentObject(dataManager)
    }
}
