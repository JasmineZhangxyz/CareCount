//
//  ToDoButton.swift
//  CareCount
//
//  Created by Jasmine Zhang on 8/28/23.
//

import SwiftUI

struct ToDoButton: View {
    let todo: ToDo
    let action: () -> Void
    let completeAction: () -> Void
    let deleteAction: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            HStack {
                Button(action: completeAction){
                    Image(systemName: todo.isDone ? "checkmark.square.fill" : "square")
                        .padding(.leading)
                }
                
                Text(todo.name)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 10)
                
                Spacer()
                
                Button(action: deleteAction) {
                    Image(systemName: "trash.fill")
                        .padding(.trailing)
                        .foregroundColor(Color("darkPink"))
                }
            }
            .padding(.vertical)
            .foregroundColor(.black)
            .background(Color.white)
            .cornerRadius(10)
            .opacity(todo.isDone ? 0.5 : 1.0)
        }
    }
}
