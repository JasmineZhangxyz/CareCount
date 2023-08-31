//
//  DayButton.swift
//  CareCount
//
//  Created by Jasmine Zhang on 8/29/23.
//

import SwiftUI

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

struct WeekdaySelectionView: View {
    @Binding var selectedDays: Set<Day>
    
    // displays all days as buttons
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
                        .font(.system(size: 16, design: .rounded))
                )
                .padding(5)
        }
    }
}
