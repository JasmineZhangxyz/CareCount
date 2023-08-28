//
//  MainView.swift
//  CareCount
//
//  Created by Jasmine Zhang on 8/28/23.
//

import SwiftUI

struct MainView: View {
    @State private var isAddingTask = false
    @State private var tasks: [Task] = []
    @State private var newTaskName: String = ""
    @State private var selectedDays: Set<Day> = []
    @State private var editingIndex: Int?
    
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
                        ForEach(0..<tasks.count, id: \.self) { index in
                            Button(action: { editingIndex = index }) {
                                HStack {
                                    Text(tasks[index].name)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading)
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    Text(tasks[index].selectedDaysAbbreviated)
                                        .padding(.trailing)
                                        .foregroundColor(.black)
                                }
                                .background(Color.white)
                                .cornerRadius(10)
                                .padding()
                            }
                            .buttonStyle(RoutineListItems())
                        }
                    }
                }
                
                Button(action: {
                    isAddingTask = true
                }) {
                    Text("+")
                        .font(.title)
                        .fontWeight(.regular)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .frame(width: 75)
                        .padding()
                        .foregroundColor(.black)
                        .background(.white)
                        .cornerRadius(25)
                }
                .padding()
                .fullScreenCover(isPresented: $isAddingTask, content: {
                    AddTaskView(isPresented: $isAddingTask, tasks: $tasks, newTaskName: $newTaskName, selectedDays: $selectedDays)
                })
            }
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
                    .padding([.top, .leading, .trailing])
                
                TextField("Task", text: $newTaskName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .padding(.bottom, 15)

                Text("Frequency")
                    .font(.headline)
                    .padding(.horizontal)
                
                HStack(spacing: 0) {
                    ForEach(Day.allCases, id: \.self) { day in
                        Button(action: {
                            if selectedDays.contains(day) {
                                selectedDays.remove(day)
                            } else {
                                selectedDays.insert(day)
                            }
                            
                            if selectedDays.count == Day.allCases.count {
                                selectedFrequency = .allWeekdays
                            }
                        }) {
                            Circle()
                                .stroke(Color("darkPink"), lineWidth: 2)
                                .frame(width: 40, height: 40)
                                .foregroundColor(selectedDays.contains(day) ? Color("darkPink") : Color.clear)
                                .background(
                                    Circle()
                                        .foregroundColor(selectedDays.contains(day) ? Color("darkPink") : Color.clear)
                                )
                                .overlay(
                                    Text(day.abbreviatedValue)
                                        .foregroundColor(selectedDays.contains(day) ? .white : Color("darkPink"))
                                        .font(.body)
                                )
                                .padding(5)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 30)


                HStack(spacing: -5) {
                    Spacer()
                    Button(action: {
                        isPresented = false
                        addTask()
                    }) {
                        Text("Add")
                            .frame(width: 55)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color("darkPink"))
                            .cornerRadius(10)
                    }
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("Cancel")
                            .frame(width: 55)
                            .padding()
                            .foregroundColor(.white)
                            .background(.gray)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
        }
    }
    
    func addTask() {
        tasks.append(Task(name: newTaskName, frequency: selectedFrequency, selectedDays: selectedDays))
        newTaskName = ""
        selectedDays = []
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
        let sortedDays = selectedDays.sorted(by: { $0.rawValue < $1.rawValue })
        return sortedDays.map { $0.abbreviatedValue }.joined(separator: " ")
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
