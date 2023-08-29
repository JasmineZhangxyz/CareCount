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
    
    // for cat picture
    @State private var imageUrl: URL?
    
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
                
                // cat picture
                if let imageUrl = imageUrl {
                    AsyncImage(url: imageUrl) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300)
                            .cornerRadius(10)
                            .padding()
                    } placeholder: {
                        Color("backgroundPink") // Placeholder while loading
                    }
                }
                
                // quote text
                Text(quoteText)
                    .font(.body)
                    .italic()
                    .foregroundColor(.black)
                    .frame(width: 300)
                    .padding(.top)
                    .padding(.bottom, 5)
                
                // quote author
                Text("- \(author)")
                    .font(.body)
                    .italic()
                    .foregroundColor(.black)
                    .padding(.bottom)
            }
            .onAppear(perform: fetchQuoteAndImage)
        }
    }
    
    // fetch quote + image
    func fetchQuoteAndImage() {
        fetchQuoteOfTheDay()
        fetchCatImage()
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
    
    func fetchCatImage() {
        guard let imageUrl = URL(string: "https://api.thecatapi.com/v1/images/search") else {
            return
        }
            
        let session = URLSession.shared
            
        let task = session.dataTask(with: imageUrl) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
                
            guard let data = data else {
                return
            }
                
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]],
                    let firstImage = json.first,
                    let imageUrlString = firstImage["url"] as? String,
                    let imageUrl = URL(string: imageUrlString) {
                        DispatchQueue.main.async {
                            self.imageUrl = imageUrl
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
