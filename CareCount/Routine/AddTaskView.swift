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
            .onAppear {
                // Print the values when the view appears
                print("oldTaskName: \(oldTaskName)")
                print("filteredRoutines: \(filteredRoutines)")
            }
        }
    }
    
    var isEditingTask: Bool {
        if filteredRoutines.firstIndex(where: { $0.name == oldTaskName }) != nil {
            return true
        }
        return false
    }
    
    func onSaveButtonTapped() {
        // Get the user's ID
        guard let userId = authManager.userId else {
            print("User ID is not available")
            closeModal()
            return
        }

        if isEditingTask {
            // Editing an existing task
            if let existingRoutineIndex = filteredRoutines.firstIndex(where: { $0.name == oldTaskName }) {
                // Update the ID of the routine to match the existing one
                let existingRoutineId = dataManager.routines[existingRoutineIndex].id
                
                // Create a new routine with the updated information
                let updatedRoutine = Routine(
                    uid: userId,
                    id: existingRoutineId,
                    name: newTaskName,
                    mon: selectedDays.contains(.mon),
                    tue: selectedDays.contains(.tue),
                    wed: selectedDays.contains(.wed),
                    thu: selectedDays.contains(.thu),
                    fri: selectedDays.contains(.fri),
                    sat: selectedDays.contains(.sat),
                    sun: selectedDays.contains(.sun)
                )
                
                // Update the routine in Firebase
                dataManager.updateRoutine(updatedRoutine)
            }
        } else {
            // Creating a new task/routine
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
            // Add the new routine to Firebase
            dataManager.addRoutine(newRoutine)
        }
        closeModal()
    }
    
    func onDeleteButtonTapped() {
        // Find the index of the routine to be deleted in the filteredRoutines array
        if let indexToDelete = filteredRoutines.firstIndex(where: { $0.name == newTaskName }) {
            // Get the routine at the found index
            let routineToDelete = filteredRoutines[indexToDelete]

            // Get the user's ID
            guard let userId = authManager.userId else {
                print("User ID is not available.")
                closeModal()
                return
            }

            // Delete the routine from Firebase
            dataManager.deleteRoutine(forUserID: userId, routineID: routineToDelete.id) { success in
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
