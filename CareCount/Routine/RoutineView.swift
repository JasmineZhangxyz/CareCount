//
//  RoutineView.swift
//  CareCount
//
//  Created by Jasmine Zhang on 8/28/23.
//

import SwiftUI

struct RoutineView: View {
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
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("darkPink"))
                
                // list of tasks
                ScrollView {
                    VStack(spacing: -10) {
                        ForEach(tasks.indices, id: \.self) { index in
                            TaskButton(task: tasks[index], action: { editTask(index) })
                                .buttonStyle(RoutineListItems())
                        }
                    }
                }
                
                // add button
                Button(action: { isAddingTask = true }) {
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
                .fullScreenCover(isPresented: $isAddingTask) {
                    AddTaskView(isPresented: $isAddingTask, tasks: $tasks, newTaskName: $newTaskName, selectedDays: $selectedDays, oldTaskName: $oldTaskName)
                }
            }
        }
    }
    
    func editTask(_ index: Int) {
        let task = tasks[index]
        newTaskName = task.name
        oldTaskName = task.name
        selectedDays = task.selectedDays
        isAddingTask = true
    }
}

struct RoutineView_Previews: PreviewProvider {
    static var previews: some View {
        RoutineView()
    }
}
