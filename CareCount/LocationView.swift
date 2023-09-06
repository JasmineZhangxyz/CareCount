//
//  LocationView.swift
//  CareCount
//
//  Created by Si Yeun Lee on 2023-09-03.
//

import SwiftUI
import CoreLocationUI

struct LocationView: View {
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        VStack {
            if let location = locationManager.location {
                            Text("Your coordinate are:\(location.longitude), \(location.latitude)")
                        } else {
                            if locationManager.isLoading {
                                LoadingView()
                            } else {
                                WelcomeView()
                                    .environmentObject(locationManager)
                            }
                        }
        }
    }
}

struct WelcomeView: View {
    
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        VStack {
                    VStack() {
                        Text("Welcome")
                            .bold()
                            .foregroundColor(Color("darkPink"))
                            .font(.system(size: 35, weight: .bold, design: .rounded))
                        
                        Text("Please share your location to get the weather in your area")
                            .foregroundColor(Color("darkGray"))
                            .font(.system(size: 14, weight: .medium))
                    }
                    .multilineTextAlignment(.center)
                    .padding()
                    
                    
                    LocationButton(.shareCurrentLocation) {
                        locationManager.requestLocation()
                    }
                    .cornerRadius(30)
                    .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("backgroundPink"))
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
    }
}
