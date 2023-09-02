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
    
    // current date
    let currentDate = Date()
    
    // variables used in ToDoView
    @State private var isAddingToDo = false
    @State private var todos: [ToDo] = []
    @State private var newToDoName = ""
    @State private var oldToDoName = ""
    @State private var currentWeather: CurrentWeather?
    
    var body: some View {
        ZStack {
            Color("backgroundPink")
                .ignoresSafeArea()
            
            VStack {
                // date
                Text(formatDate(currentDate))
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.top, 75)
                
                // title
                Text("To-Do List")
                    .font(.system(size: 45, weight: .bold, design: .rounded))
                    .foregroundColor(Color("darkPink"))
                    .padding(.top, 3)
                
                // Display current weather
                if let currentWeather = currentWeather {
                    Text("Current Weather: \(currentWeather.temperature)°C, Weather Code: \(currentWeather.weathercode)")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.top, 20)
                }
                
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
                            .buttonStyle(ListItems())
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
                        .font(.system(size: 32, design: .rounded))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .frame(width: 75)
                        .padding()
                        .foregroundColor(.black)
                        .background(Color.white)
                        .cornerRadius(25)
                }
                .padding()
                .fullScreenCover(isPresented: $isAddingToDo) {
                    AddToDoView(isPresented: $isAddingToDo, todos: $todos, newToDoName: $newToDoName, oldToDoName: $oldToDoName)
                }
            }
            .onAppear {
                fetchWeather() // Fetch weather data when the view appears
            }
        }
    }
    
    func editToDo(_ index: Int) {
        newToDoName = todos[index].name
        oldToDoName = todos[index].name
        isAddingToDo = true
    }
    
    func completeToDo(_ index: Int) {
        todos[index].isDone.toggle()
    }
    
    func deleteToDo(at index: Int) {
        todos.remove(at: index)
        newToDoName = ""
    }
    
    // format the date
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    // Function to fetch weather data
    private func fetchWeather() {
        if let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=43.7001&longitude=-79.4163&current_weather=true") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    if let decodedResponse = try? JSONDecoder().decode(WeatherResponse.self, from: data) {
                        DispatchQueue.main.async {
                            self.currentWeather = decodedResponse.current_weather
                        }
                        return
                    }
                }
                // Handle errors here
            }.resume()
        }
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

struct WeatherResponse: Codable {
    let current_weather: CurrentWeather
}

struct CurrentWeather: Codable {
    let temperature: Double
    let weathercode: Int
    // Add other weather properties you want to display
}

struct ToDoView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoView()
    }
}
