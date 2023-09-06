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
    
    @State private var isInfoViewShown = false
    @State private var selectedCity = "Toronto (Default)"

    
    var body: some View {
        ZStack {
            Color("backgroundPink")
                .ignoresSafeArea()
            
            VStack {
                // current weather
                if let currentWeather = currentWeather {
                    HStack {
                        HStack {
                            iconForWeatherCode(currentWeather.weathercode)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color("darkPink"))
                            Text(String(format: "%.0f°C", currentWeather.temperature))
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(Color("darkPink"))
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(Color("darkGray"))
                                .onTapGesture {
                                    isInfoViewShown = true
                                }
                                .fullScreenCover(isPresented: $isInfoViewShown) {
                                    SelectLocationView(isInfoViewShown: $isInfoViewShown, selectedCity: $selectedCity)
                                }

                        }
                    }
                    .padding(.top, 75)
                }
                
                // date
                Text(formatDate(currentDate))
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.top, 10)
                
                // title
                Text("To-Do List")
                    .font(.system(size: 45, weight: .bold, design: .rounded))
                    .foregroundColor(Color("darkPink"))
                    .padding(.top, 3)
                
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
            .onChange(of: selectedCity) { _ in
                fetchWeather()
            }
        }
    }
    
    // weather
    func iconForWeatherCode(_ code: Int) -> Image {
        switch code {
        case 0:
            return Image(systemName: "sun.min.fill")
        case 1, 2:
            return Image(systemName: "cloud.sun.fill")
        case 3:
            return Image(systemName: "cloud.fill")
        case 45, 48:
            return Image(systemName: "cloud.fog.fill")
        case 51, 53, 55, 56, 57:
            return Image(systemName: "cloud.drizzle.fill")
        case 61, 63, 66, 80, 81:
            return Image(systemName: "cloud.rain.fill")
        case 65, 67, 82:
            return Image(systemName: "cloud.heavyrain.fill")
        case 71, 73, 75, 85, 86:
            return Image(systemName: "snowflake")
        case 77:
            return Image(systemName: "cloud.hail.fill")
        case 95, 96, 99:
            return Image(systemName: "cloud.bolt.fill")
        default:
            return Image(systemName: "thermometer.medium")
        }
    }
    
    let cityCoordinates: [String: (latitude: Double, longitude: Double)] = [
        "Toronto (Default)": (43.7001, -79.4163),
        "New York": (40.7128, -74.0060),
        "Chicago": (41.8781, -87.6298),
        "San Francisco": (37.7749, -122.4194),
        "Seattle": (47.6062, -122.3321)
    ]
    
    func fetchWeather() {
        if let (latitude, longitude) = cityCoordinates[selectedCity] {
            let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current_weather=true"
            if let url = URL(string: urlString) {
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
    }
    
    // format the date
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    // todo
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

    // progress bar
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
    // can add other weather properties to display here
}

struct SelectLocationView: View {
    @State private var selectedCityIndex = 0
    let cities = ["Toronto (Default)", "New York", "Chicago", "San Francisco", "Seatle"]
    @Binding var isInfoViewShown: Bool
    @Binding var selectedCity: String
    
    var body: some View {
        VStack {
            VStack() {
                Text("Show weather for")
                    .bold()
                    .foregroundColor(Color("darkPink"))
                    .font(.system(size: 35, weight: .bold, design: .rounded))
                
                Picker("Select City", selection: $selectedCityIndex) {
                    ForEach(0..<cities.count, id: \.self) { index in
                        Text(cities[index]).tag(index)
                    }
                }
                .pickerStyle(InlinePickerStyle())
                .padding(.top, -40)
                .onChange(of: selectedCityIndex) { newValue in
                    selectedCity = cities[newValue]
                }
                
                Button("Save") {
                    isInfoViewShown = false
                }
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(Color("darkPink"))
            }
            .multilineTextAlignment(.center)
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("backgroundPink"))
    }
}

struct ProgressBar: View {
    var value: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: geometry.size.height / 2)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color.gray)
                
                RoundedRectangle(cornerRadius: geometry.size.height / 2)
                    .frame(width: min(CGFloat(self.value) * geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color("darkPink"))
            }
        }
    }
}

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

struct ToDoView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoView()
    }
}
