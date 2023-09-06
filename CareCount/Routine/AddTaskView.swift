//
//  AddTaskView.swift
//  CareCount
//
//  Created by Jasmine Zhang on 8/29/23.
//

import SwiftUI
import Firebase

enum Day: String, CaseIterable {
    case sun = "Sun"
    case mon = "Mon"
    case tue = "Tue"
    case wed = "Wed"
    case thu = "Thu"
    case fri = "Fri"
    case sat = "Sat"
    
    var abbreviatedValue: String {
        switch self {
        case .sun, .sat:
            return "S"
        case .mon:
            return "M"
        case .tue, .thu:
            return "T"
        case .wed:
            return "W"
        case .fri:
            return "F"
        }
    }
}

struct AddTaskView: View {
    // for database
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var dataManager: DataManager

    @Binding var isPresented: Bool
    @Binding var tasks: [Task]
    @Binding var newTaskName: String
    @Binding var selectedDays: Set<Day>
    @Binding var oldTaskName: String
    @Binding var filteredRoutines: [Routine]

    var body: some View {
        ZStack {
            Color("popupPink")
                .ignoresSafeArea()
            VStack {
                
                // title
                Text(isEditingTask ? "Edit task" : "Add a task")
                    .font(.system(size: 45, weight: .bold, design: .rounded))
                    .foregroundColor(Color("darkPink"))
                    .padding(.horizontal)
                    .padding(.top)

                // task name
                TextField("Task", text: $newTaskName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.bottom, 50)

                // frequency title
                Text("Frequency")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(Color("darkPink"))
                    .padding(.horizontal)

                // days of week task is assigned
                WeekdaySelectionView(selectedDays: $selectedDays)
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                
                // if new task: add, cancel buttons; if editing task: save, delete, cancel buttons
                ActionButtonsView(
                    saveAction: { onSaveButtonTapped() },
                    deleteAction: { onDeleteButtonTapped() },
                    cancelAction: { closeModal() },
                    isEditing: isEditingTask
                )
                .padding(.horizontal)
            }
            .padding()
        }
    }
    
    var isEditingTask: Bool {
        if tasks.firstIndex(where: { $0.name == oldTaskName }) != nil {
            return true
        }
        return false
    }
    
    func onSaveButtonTapped() {
        // get userId
        guard let userId = authManager.userId else {
            print("User ID is not available. Test")
            closeModal()
            return
        }
        
        /*if isEditingTask, let task_index = tasks.firstIndex(where: { $0.name == oldTaskName }) {
            if let routine_index = filteredRoutines.firstIndex(where: { $0.id == tasks[task_index].id }) {
                // Update the properties of the existing routine
                filteredRoutines[routine_index].name = newTaskName
                filteredRoutines[routine_index].mon = selectedDays.contains(.mon)
                filteredRoutines[routine_index].tue = selectedDays.contains(.tue)
                filteredRoutines[routine_index].wed = selectedDays.contains(.wed)
                filteredRoutines[routine_index].thu = selectedDays.contains(.thu)
                filteredRoutines[routine_index].fri = selectedDays.contains(.fri)
                filteredRoutines[routine_index].sat = selectedDays.contains(.sat)
                filteredRoutines[routine_index].sun = selectedDays.contains(.sun)
                
                // Update routine in Firebase
                dataManager.updateRoutine(filteredRoutines[routine_index])
            }
            
            // Update local task
            tasks[task_index] = Task(name: newTaskName, selectedDays: selectedDays)
        } else {
            // Create a new routine
            let newRoutine = Routine(
                uid: userId,
                id: UUID().uuidString, // Generate a new unique ID
                name: newTaskName,
                mon: selectedDays.contains(.mon),
                tue: selectedDays.contains(.tue),
                wed: selectedDays.contains(.wed),
                thu: selectedDays.contains(.thu),
                fri: selectedDays.contains(.fri),
                sat: selectedDays.contains(.sat),
                sun: selectedDays.contains(.sun)
            )
            
            // Add new routine to Firebase
            dataManager.addRoutine(newRoutine)
            
            // Add new task locally
            tasks.append(Task(name: newTaskName, selectedDays: selectedDays))
        }*/
        
        closeModal()
    }

    
    func onDeleteButtonTapped() {
        if let index = tasks.firstIndex(where: { $0.name == newTaskName }) {
            tasks.remove(at: index) // remove locally
            
            // get userId
            guard let userId = authManager.userId else {
                print("User ID is not available.")
                closeModal()
                return
            }
            
            // remove from Firebase
            dataManager.deleteRoutine(forUserID: userId, withRoutineName: newTaskName) { success in
                if success {
                    print("Routine deleted from Firebase.")
                } else {
                    print("Failed to delete routine from Firebase.")
                }
                closeModal()
            }
        }
    }
    
    func closeModal() { // equivalent to onCancelButtonTapped
        newTaskName = ""
        selectedDays = []
        isPresented = false
    }
}

struct WeekdaySelectionView: View {
    @Binding var selectedDays: Set<Day>
    
    var body: some View {
        HStack(spacing: 0) {
            // displays each weekday as a round button
            ForEach(Day.allCases, id: \.self) { day in
                // if button is clicked, the day is (un)selected for a task
                Button(action: { toggleDaySelection(day) }) {
                    // styling of button
                    Circle()
                        .stroke(Color("darkPink"), lineWidth: 2)
                        .frame(width: 40, height: 40)
                        .foregroundColor(selectedDays.contains(day) ? Color("darkPink") : .clear)
                        .background(
                            Circle()
                                .foregroundColor(selectedDays.contains(day) ? Color("darkPink") : .clear)
                        )
                        .overlay(
                            Text(day.abbreviatedValue)
                                .foregroundColor(selectedDays.contains(day) ? .white : Color("darkPink"))
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                        )
                        .padding(5)
                }
            }
        }
    }
    
    private func toggleDaySelection(_ day: Day) {
        if selectedDays.contains(day) {
            selectedDays.remove(day)
        } else {
            selectedDays.insert(day)
        }
    }
}

struct ActionButtonsView: View {
    let saveAction: () -> Void
    let deleteAction: () -> Void
    let cancelAction: () -> Void
    let isEditing: Bool
    
    var body: some View {
        HStack {
            Spacer()
            
            Button(action: saveAction) {
                Text(isEditing ? "Save" : "Add")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color("darkPink"))
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .cornerRadius(10)
            }
            
            // only show delete button when editing existing task
            if isEditing {
                Button(action: deleteAction) {
                    Text("Delete")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.gray)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .cornerRadius(10)
                }
            }
            
            Button(action: cancelAction) {
                Text("Cancel")
                    .padding()
                    .foregroundColor(Color("darkPink"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("darkPink"), lineWidth: 2)
                    )
                    .font(.system(size: 18, weight: .bold, design: .rounded))
            }
        }
    }
}
