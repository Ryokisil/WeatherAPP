//
//  ContentView.swift
//  OPWeather
//
//  Created by silvia on 2024/06/21.
//

import SwiftUI
import CoreLocation
import SpriteKit

struct ContentView: View {
    @State private var city: String = ""
    @StateObject private var viewModel = WeatherViewModel()
    @StateObject private var locationManager = LocationManager()
    
    // デバッグ用の変数（テスト時に強制的にアニメーションや画像を表示）
    @State private var isDebugNight: Bool = true
    @State private var isDebugMode: Bool = true

    var body: some View {
        ZStack {
            // 背景にアニメーションや背景画像を追加
            if viewModel.weatherType == "rain" {
                SpriteView(scene: RainScene(size: UIScreen.main.bounds.size))
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .ignoresSafeArea() // 全画面にアニメーションを表示
            } else if viewModel.weatherType == "clear" {
                //18時以降なら夜に合わせた画像を表示する
                let isNight = getCurrentHour() >= nightStartHour || getCurrentHour() < 6
                
                if isNight {
                    Image ("clear night sky")
                        .resizable()
                        .ignoresSafeArea()
                } else {
                    Image ("sun")
                    LinearGradient(gradient: Gradient(colors: [Color.blue, Color.white]),
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                    .background(Color.clear)
                    .ignoresSafeArea()
                }
            } else if viewModel.weatherType == "cloud" {
                Image ("cloudy sky")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            } else if viewModel.weatherType == "snow" {
                //SpriteView(scene: )
            }
            
            
            
            VStack {
                if let location = locationManager.location {
                    VStack {
                        Text("\(viewModel.temperature)")
                        Text("\(viewModel.description)")
                        HStack {
                            Text(viewModel.high)
                            Text(viewModel.low)
                        }
                        
                    }
                    .padding()
                    .onAppear {
                        viewModel.fetchWeather(for: location)
                    }
                } else {
                    Text("Fetching location...")
                        .onAppear {
                            locationManager.startUpdatingLocation()
                        }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



