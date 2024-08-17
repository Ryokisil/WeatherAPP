//
//  WeatherViewModel.swift
//  OPWeather
//
//  Created by silvia on 2024/06/21.
//

import Foundation
import Combine
import CoreLocation

// WeatherViewModelクラスで天気情報の取得とデータの公開を管理する
class WeatherViewModel: ObservableObject {
    // ユーザーに公開される天気情報のプロパティ
    @Published var temperature: String = ""
    @Published var description: String = ""
    @Published var weatherType: String = ""
    @Published var high: String = ""
    @Published var low: String = ""

    // WeatherServiceのインスタンス
    private let weatherService = WeatherService()

    // 都市名を指定して天気情報を取得するメソッド
    func fetchWeather(_ city: String) {
        DispatchQueue.global(qos: .background).async { //バックグラウンドでネットワークリクエストを実行
            // 天気情報を取得するためにWeatherServiceを呼び出す
            self.weatherService.fetchWeather(for: city) { weather in
                // weatherDataが存在するかどうかを確認
                if let weather = weather {
                    // weatherDataが存在する場合の処理
                    DispatchQueue.main.async {
                        self.temperature = "\(weather.temperature)°C"
                        self.description = weather.description
                        self.weatherType = self.getWeatherType(from: weather.description, weatherCode: weather.weatherCode)
                        self.high = "H: \(weather.high)°C"
                        self.low = "L: \(weather.low)°C"
                    }
                }
            }
        }
    }

    // 現在の位置情報を使用して天気情報を取得するメソッド
    func fetchWeather(for location: CLLocation) {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
        DispatchQueue.global(qos: .background).async { //バックグラウンドでネットワークリクエストを実行
            self.weatherService.fetchWeather(for: latitude, longitude: longitude) { weather in
                if let weather = weather {
                    DispatchQueue.main.async {
                        self.temperature = "\(weather.temperature)°C"
                        self.description = weather.description
                        self.weatherType = self.getWeatherType(from: weather.description, weatherCode: weather.weatherCode)
                        self.high = "H: \(weather.high)°C"
                        self.low = "L: \(weather.low)°C"
                    }
                }
            }
        }
    }
    
    private func getWeatherType(from description: String, weatherCode: Int) -> String {
        
        switch weatherCode {
               case 200...232:
                   return "thunderstorm"
               case 300...321:
                   return "drizzle"
               case 500...531:
                   return "rain"
               case 600...622:
                   return "snow"
               case 701...781:
                   return "atmosphere"
               case 800:
                   return "clear"
               case 801...804:
                   return "cloud"
               default:
                   break
        }
        
        let lowercasedDescription = description.lowercased() // 大文字と小文字の違いを無視するために小文字化
        if lowercasedDescription.contains("rain") || lowercasedDescription.contains("drizzle") || lowercasedDescription.contains("shower") {
            return "rain"
        } else if lowercasedDescription.contains("cloud") || lowercasedDescription.contains("overcast") {
            return "cloud"
        } else if lowercasedDescription.contains("sunny") || lowercasedDescription.contains("clear") {
            return "clear"
        } else if lowercasedDescription.contains("snow") {
            return "snow"
        } else if lowercasedDescription.contains("thunderstorm") {
            return "thunderstorm"
        }
        
        
        return "unknown"
    }
}

// 夜の開始時刻を設定する変数
let nightStartHour = 18 // 18時（午後6時）からを夜と設定

// 現在の時刻を取得する関数
func getCurrentHour() -> Int { //-> Intで戻り値を整数型にする
    let currentTime = Date() // 現在の日付と時刻を取得し、currentTimeという名前の定数に格納
    let calendar = Calendar.current // 現在のカレンダーを取得
    return calendar.component(.hour, from: currentTime) // 現在の日付から時間部分を取得し、返す
}

