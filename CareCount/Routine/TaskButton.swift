//
//  TaskButton.swift
//  CareCount
//
//  Created by Jasmine Zhang on 8/29/23.
//

import SwiftUI

struct TaskButton: View {
    let task: Task
    let action: () -> Void
    
    var body: some View {
        // each task is a button, with name on left and frequency on right
        // clicking on a task lets you edit through AddTaskView
        Button(action: action) {
            HStack {
                Text(task.name)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                
                Spacer()
                
                Text(task.selectedDaysAbbreviated)
                    .font(.system(size: 14, design: .rounded))
                    .padding(.trailing)
            }
            .padding(.vertical)
            .foregroundColor(.black)
            .background(.white)
            .cornerRadius(10)
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
