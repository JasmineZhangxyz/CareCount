//
//  AddToDoView.swift
//  CareCount
//
//  Created by Jasmine Zhang on 8/28/23.
//

import SwiftUI

struct AddToDoView: View {
    @Binding var isPresented: Bool
    @Binding var todos: [ToDo]
    @Binding var newToDoName: String
    @Binding var oldToDoName: String
    
    var body: some View {
        ZStack {
            Color("popupPink")
                .ignoresSafeArea()
            
            VStack {
                Text(isEditingToDo ? "Edit To-Do" : "Add To-Do")
                    .font(.system(size: 45, weight: .bold, design: .rounded))
                    .foregroundColor(Color("darkPink"))
                    .padding(.horizontal)
                    .padding(.top)

                TextField("To-Do", text: $newToDoName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .padding(.bottom, 15)
                
                HStack {
                    Spacer()
                    
                    Button(action: onSaveButtonTapped) {
                        Text(isEditingToDo ? "Save" : "Add")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("darkPink"))
                            .cornerRadius(10)
                    }
                    
                    Button(action: closeModal) {
                        Text("Cancel")
                            .foregroundColor(Color("darkPink"))
                            .padding()
                            .background(Color.clear)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("darkPink"), lineWidth: 2)
                            )
                    }
                }
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .padding(.horizontal)
            }
            .padding()
        }
    }
    
    var isEditingToDo: Bool {
        todos.contains(where: { $0.name == oldToDoName })
    }
    
    func onSaveButtonTapped() {
        if let index = todos.firstIndex(where: { $0.name == oldToDoName }) {
            // update task
            todos[index] = ToDo(name: newToDoName, isNew: false, isDone: false)
        } else {
            // add task
            todos.append(ToDo(name: newToDoName, isNew: true, isDone: false))
        }
        closeModal()
    }
    
    func closeModal() {
        newToDoName = ""
        isPresented = false
    }
}
