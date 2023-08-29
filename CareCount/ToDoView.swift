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
                // title
                Text("To-Do List")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("darkPink"))
                    .padding(.top, 50)
                
                // to-do items
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
                
                // progress Bar
                if !todos.isEmpty {
                    ProgressBar(value: completionPercentage)
                        .frame(height: 25)
                        .padding(.horizontal, 40)
                }
                
                // add to-do item button
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
    
    // calculate the completion percentage for the progress bar
    var completionPercentage: Double {
        let completedCount = todos.filter { $0.isDone }.count
        return Double(completedCount) / Double(todos.count)
    }
}

struct ToDo {
    var name: String
    var isNew: Bool
    var isDone: Bool
}

struct ToDoView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoView()
    }
}
