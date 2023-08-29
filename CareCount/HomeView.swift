//
//  HomeView.swift
//  CareCount
//
//  Created by Jasmine Zhang on 8/28/23.
//

import SwiftUI

struct HomeView: View {
    // for quote
    @State private var quoteText: String = ""
    @State private var author: String = ""
    
    // for navbar footer
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack {
            Color("backgroundPink")
                .ignoresSafeArea()
            VStack {
                Text("Home")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("darkPink"))
                
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
    
    // fetch quote of the day
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
