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
    
    // for quote
    @State private var quoteText: String = ""
    @State private var author: String = ""
    
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
                
                Text(quoteText)
                    .font(.body)
                    .italic()
                    .foregroundColor(.black)
                    .padding([.top, .leading, .trailing])
                
                Text("- \(author)")
                    .font(.body)
                    .italic()
                    .foregroundColor(.black)
                    .padding(.bottom)
            }
            .onAppear(perform: fetchQuoteOfTheDay)
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
    
    // function to fetch quote
    func fetchQuoteOfTheDay() {
        guard let url = URL(string: "https://zenquotes.io/api/today") else {
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]],
                   let firstQuote = json.first,
                   let quoteText = firstQuote["q"] as? String,
                   let author = firstQuote["a"] as? String {
                    DispatchQueue.main.async {
                        self.quoteText = quoteText
                        self.author = author
                    }
                }
            } catch {
                print("JSON parsing error: \(error)")
            }
        }
        
        task.resume()
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
