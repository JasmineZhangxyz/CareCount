//
//  ToDoView.swift
//  CareCount
//
//  Created by Jasmine Zhang on 8/28/23.
//

import SwiftUI

struct ToDoView: View {
    // for navigation
    @State private var tabSelected: Tab = .todo
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    // variables used in ToDoView
    @State private var isAddingToDo = false
    @State private var todos: [ToDo] = []
    @State private var newToDoName = ""
    
    var body: some View {
        ZStack {
            Color("backgroundPink")
                .ignoresSafeArea()
            
            VStack {
                Text("To-Do List")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("darkPink"))
                    .padding(.top, 50)
                
                ScrollView {
                    VStack(spacing: -10) {
                        ForEach(todos.indices, id: \.self) { index in
                            ToDoButton(
                                todo: todos[index],
                                action: { editToDo(index) },
                                completeAction: { completeToDo(index) },
                                deleteAction: { deleteToDo(at: index) }
                            )
                            .buttonStyle(RoutineListItems())
                        }
                    }
                }
                
                Button(action: { isAddingToDo = true }) {
                    Text("+")
                        .font(.title)
                        .fontWeight(.regular)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .frame(width: 75)
                        .padding()
                        .foregroundColor(.black)
                        .background(Color.white)
                        .cornerRadius(25)
                }
                .padding()
                .fullScreenCover(isPresented: $isAddingToDo) {
                    AddToDoView(isPresented: $isAddingToDo, todos: $todos, newToDoName: $newToDoName)
                }
            }
        }
    }
    
    func editToDo(_ index: Int) {
        newToDoName = todos[index].name
        isAddingToDo = true
    }
    
    func completeToDo(_ index: Int) {
        todos[index].isDone.toggle()
    }
    
    func deleteToDo(at index: Int) {
        todos.remove(at: index)
        newToDoName = ""
    }
}

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
            updateToDo(at: index)
        } else {
            addToDo()
        }
        isPresented = false
    }
    
    var isEditingToDo: Bool {
        todos.contains(where: { $0.name == newToDoName })
    }
    
    func onCancelButtonTapped() {
        isPresented = false
    }
    
    func addToDo() {
        todos.append(ToDo(name: newToDoName, isDone: false))
        newToDoName = ""
    }
    
    func updateToDo(at index: Int) {
        todos[index] = ToDo(name: newToDoName, isDone: false)
        newToDoName = ""
    }
}

struct ToDo {
    var name: String
    var isDone: Bool
}

struct ToDoView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoView()
    }
}
