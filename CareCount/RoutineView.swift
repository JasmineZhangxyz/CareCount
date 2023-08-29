//
//  RoutineView.swift
//  CareCount
//
//  Created by Jasmine Zhang on 8/28/23.
//

import SwiftUI

struct RoutineView: View {
    @State private var isAddingTask = false
    @State private var tasks: [Task] = []
    @State private var newTaskName = ""
    @State private var selectedDays: Set<Day> = []
    @State private var editingIndex: Int?
    
    @State private var tabSelected: Tab = .routine
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
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
                
                ScrollView {
                    VStack(spacing: -10) {
                        ForEach(tasks.indices, id: \.self) { index in
                            TaskButton(task: tasks[index], action: { editTask(index) })
                                .buttonStyle(RoutineListItems())
                        }
                    }
                }
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
                    AddTaskView(isPresented: $isAddingTask, tasks: $tasks, newTaskName: $newTaskName, selectedDays: $selectedDays)
                }
            }
        }
    }
    
    func editTask(_ index: Int) {
        editingIndex = index
        let task = tasks[index]
        newTaskName = task.name
        selectedDays = task.selectedDays
        isAddingTask = true
    }
}

struct TaskButton: View {
    let task: Task
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(task.name)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                    .foregroundColor(.black)
                
                Spacer()
                
                Text(task.selectedDaysAbbreviated)
                    .padding(.trailing)
                    .foregroundColor(.black)
            }
            .padding()
            .foregroundColor(.black)
            .background(Color.white)
            .cornerRadius(10)
        }
    }
}

struct AddTaskView: View {
    @Binding var isPresented: Bool
    @Binding var tasks: [Task]
    @Binding var newTaskName: String
    @Binding var selectedDays: Set<Day>
    
    @State private var selectedFrequency: Frequency = .daily

    var body: some View {
        ZStack {
            Color("popupPink")
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                Text("Add a task")
                    .font(.title)
                    .padding(.horizontal)
                    .padding(.top)

                TextField("Task", text: $newTaskName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .padding(.bottom, 15)

                Text("Frequency")
                    .font(.headline)
                    .padding(.horizontal)

                WeekdaySelectionView(selectedDays: $selectedDays, selectedFrequency: $selectedFrequency)
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                
                // Show the delete button only when editing an existing task
                if isEditingTask {
                    ActionButtonsView(
                        saveAction: { onSaveButtonTapped() },
                        deleteAction: { onDeleteButtonTapped() },
                        cancelAction: { onCancelButtonTapped() }
                    )
                    .padding(.horizontal)
                } else {
                    // Show only save and cancel buttons when creating a task
                    HStack {
                        Spacer()
                        
                        Button("Save") {
                            onSaveButtonTapped()
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color("darkPink"))
                        .cornerRadius(10)
                        
                        Button("Cancel") {
                            onCancelButtonTapped()
                        }
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
            }
            .padding()
        }
    }
    
    func onSaveButtonTapped() {
        if let index = tasks.firstIndex(where: { $0.name == newTaskName }) {
            updateTask(at: index)
        } else {
            addTask()
        }
        isPresented = false
    }
    
    var isEditingTask: Bool {
        if let index = tasks.firstIndex(where: { $0.name == newTaskName }) {
            return true
        }
        return false
    }
    
    func onDeleteButtonTapped() {
        if let index = tasks.firstIndex(where: { $0.name == newTaskName }) {
            deleteTask(at: index)
            isPresented = false
        }
    }
    
    func onCancelButtonTapped() {
        isPresented = false
    }
    
    func addTask() {
        tasks.append(Task(name: newTaskName, frequency: selectedFrequency, selectedDays: selectedDays))
        clearFields()
    }
    
    func updateTask(at index: Int) {
        tasks[index] = Task(name: newTaskName, frequency: selectedFrequency, selectedDays: selectedDays)
        clearFields()
    }
        
    func deleteTask(at index: Int) {
        tasks.remove(at: index)
        clearFields()
    }
    
    func clearFields() {
        newTaskName = ""
        selectedDays = []
    }
}

struct WeekdaySelectionView: View {
    @Binding var selectedDays: Set<Day>
    @Binding var selectedFrequency: Frequency
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Day.allCases, id: \.self) { day in
                DayButton(day: day, isSelected: selectedDays.contains(day)) {
                    toggleDaySelection(day)
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
        
        if selectedDays.count == Day.allCases.count {
            selectedFrequency = .allWeekdays
        }
    }
}

struct DayButton: View {
    let day: Day
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .stroke(Color("darkPink"), lineWidth: 2)
                .frame(width: 40, height: 40)
                .foregroundColor(isSelected ? Color("darkPink") : Color.clear)
                .background(
                    Circle()
                        .foregroundColor(isSelected ? Color("darkPink") : Color.clear)
                )
                .overlay(
                    Text(day.abbreviatedValue)
                        .foregroundColor(isSelected ? .white : Color("darkPink"))
                        .font(.body)
                )
                .padding(5)
        }
    }
}

struct ActionButtonsView: View {
    let saveAction: () -> Void
    let deleteAction: () -> Void
    let cancelAction: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
            
            Button(action: saveAction) {
                ActionButton(label: "Save", textcolor: Color.white, color: Color("darkPink"))
            }
            
            Button(action: deleteAction) {
                ActionButton(label: "Delete", textcolor: Color.white, color: Color.gray)
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


enum Frequency: String, CaseIterable {
    case daily = "Daily"
    case allWeekdays = "All Weekdays"
}

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

struct Task {
    var name: String
    var frequency: Frequency
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
        RoutineView()
    }
}
