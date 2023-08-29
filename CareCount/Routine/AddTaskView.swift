//
//  AddTaskView.swift
//  CareCount
//
//  Created by Jasmine Zhang on 8/29/23.
//

import SwiftUI

struct AddTaskView: View {
    @Binding var isPresented: Bool
    @Binding var tasks: [Task]
    @Binding var newTaskName: String
    @Binding var selectedDays: Set<Day>
    @Binding var oldTaskName: String
    
    @State private var selectedFrequency: Frequency = .daily

    var body: some View {
        ZStack {
            Color("popupPink")
                .ignoresSafeArea()
            VStack {
                Text(isEditingTask ? "Edit task" : "Add a task")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("darkPink"))
                    .padding(.horizontal)
                    .padding(.top)

                TextField("Task", text: $newTaskName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.bottom, 50)

                Text("Frequency")
                    .font(.headline)
                    .foregroundColor(Color("darkPink"))
                    .padding(.horizontal)

                WeekdaySelectionView(selectedDays: $selectedDays, selectedFrequency: $selectedFrequency)
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
        if let index = tasks.firstIndex(where: { $0.name == oldTaskName }) {
            // update task
            tasks[index] = Task(name: newTaskName, frequency: selectedFrequency, selectedDays: selectedDays)
        } else {
            // add task
            tasks.append(Task(name: newTaskName, frequency: selectedFrequency, selectedDays: selectedDays))
        }
        closeModal()
    }
    
    func onDeleteButtonTapped() {
        if let index = tasks.firstIndex(where: { $0.name == newTaskName }) {
            tasks.remove(at: index)
        }
        closeModal()
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
            }
            
            if isEditing {
                Button(action: deleteAction) {
                    ActionButton(label: "Delete", textcolor: Color.white, color: Color.gray)
                }
            }
            
            Button(action: cancelAction) {
                ActionButton(label: "Cancel", textcolor: Color("darkPink"), color: Color.clear)
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
