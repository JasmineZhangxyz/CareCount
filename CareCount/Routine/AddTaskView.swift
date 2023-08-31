//
//  AddTaskView.swift
//  CareCount
//
//  Created by Jasmine Zhang on 8/29/23.
//

import SwiftUI
import Firebase

struct AddTaskView: View {
    // for database
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var dataManager: DataManager

    @Binding var isPresented: Bool
    @Binding var tasks: [Task]
    @Binding var newTaskName: String
    @Binding var selectedDays: Set<Day>
    @Binding var oldTaskName: String

    var body: some View {
        ZStack {
            Color("popupPink")
                .ignoresSafeArea()
            VStack {
                Text(isEditingTask ? "Edit task" : "Add a task")
                    .font(.system(size: 45, weight: .bold, design: .rounded))
                    .foregroundColor(Color("darkPink"))
                    .padding(.horizontal)
                    .padding(.top)

                TextField("Task", text: $newTaskName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.bottom, 50)

                Text("Frequency")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(Color("darkPink"))
                    .padding(.horizontal)

                WeekdaySelectionView(selectedDays: $selectedDays)
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                
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
        guard let userId = authManager.userId else {
            print("User ID is not available.")
            closeModal()
            return
        }
        
        let newRoutine = Routine(
            id: userId,
            name: newTaskName,
            mon: selectedDays.contains(.mon),
            tue: selectedDays.contains(.tue),
            wed: selectedDays.contains(.wed),
            thu: selectedDays.contains(.thu),
            fri: selectedDays.contains(.fri),
            sat: selectedDays.contains(.sat),
            sun: selectedDays.contains(.sun)
        )
        
        if isEditingTask, let index = tasks.firstIndex(where: { $0.name == oldTaskName }) {
            // update task locally
            tasks[index] = Task(name: newTaskName, selectedDays: selectedDays)
            
            // update routine in Firebase
            dataManager.updateRoutine(newRoutine)
        } else {
            // add task locally
            tasks.append(Task(name: newTaskName, selectedDays: selectedDays))
            
            // add routine to Firebase
            dataManager.addRoutine(newRoutine)
        }
        closeModal()
    }
    
    func onDeleteButtonTapped() {
        if let index = tasks.firstIndex(where: { $0.name == newTaskName }) {
            tasks.remove(at: index)
            
            guard let userId = authManager.userId else {
                print("User ID is not available.")
                closeModal()
                return
            }
            
            // Remove the routine from Firebase
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
        // clear fields and close popup
        newTaskName = ""
        selectedDays = []
        isPresented = false
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
                ActionButton(label: isEditing ? "Save" : "Add", textcolor: Color.white, color: Color("darkPink"))
                    .font(.system(size: 18, weight: .bold, design: .rounded))
            }
            
            if isEditing {
                Button(action: deleteAction) {
                    ActionButton(label: "Delete", textcolor: Color.white, color: Color.gray)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                }
            }
            
            Button(action: cancelAction) {
                ActionButton(label: "Cancel", textcolor: Color("darkPink"), color: Color.clear)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("darkPink"), lineWidth: 2)
                    )
            }
        }
    }
}

struct ActionButton: View {
    let label: String
    let textcolor: Color
    let color: Color
    
    var body: some View {
        Text(label)
            .padding()
            .foregroundColor(textcolor)
            .background(color)
            .cornerRadius(10)
    }
}
