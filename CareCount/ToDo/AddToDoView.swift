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
    
    var body: some View {
        ZStack {
            Color("popupPink")
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text("Add a To-Do")
                    .font(.title)
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
                    
                    Button("Cancel", action: onCancelButtonTapped)
                        .foregroundColor(Color("darkPink"))
                        .padding()
                        .background(Color.clear)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("darkPink"), lineWidth: 2)
                        )
                }
                .padding(.horizontal)
            }
            .padding()
        }
    }
    
    func onSaveButtonTapped() {
        if let index = todos.firstIndex(where: { $0.name == newToDoName }) {
            todos[index] = ToDo(name: newToDoName, isNew: false, isDone: false)
        } else {
            todos.append(ToDo(name: newToDoName, isNew: true, isDone: false))
        }
        newToDoName = ""
        isPresented = false
    }
    
    var isEditingToDo: Bool {
        todos.contains(where: { $0.name == newToDoName })
    }
    
    func onCancelButtonTapped() {
        isPresented = false
    }
}
