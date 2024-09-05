
import Foundation
import Combine
import CoreLocation

// 天気情報を管理するクラス
class WeatherViewModel: ObservableObject {
    // ユーザーに公開される天気情報のプロパティ
    @Published var temperature: String = ""
    @Published var description: String = ""
    @Published var weatherType: String = ""
    @Published var high: String = ""
    @Published var low: String = ""

    private let weatherService: WeatherServiceProtocol
    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
    }

    // 都市名を指定して天気情報を取得する
    func fetchWeather(for city: String) {
        DispatchQueue.global(qos: .background).async { // 非同期でネットワークリクエストをバックグラウンドで実行
           
            self.weatherService.fetchWeather(for: city) { weather in
                // データが取得できたらUIをメインスレッドで更新
                if let weather = weather {
                    DispatchQueue.main.async {
                        self.temperature = String(format: "%.0f°C", weather.temperature)
                        self.description = weather.description
                        self.weatherType = self.getWeatherType(from: weather.description, weatherCode: weather.weatherCode)
                        self.high = String(format: "H: %.0f°C", weather.high)
                        self.low = String(format: "L: %.0f°C", weather.low)
                    }
                }
            }
        }
    }

    // 現在の位置情報を使用して天気情報を取得する
    func fetchWeather(for location: CLLocation) {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
        DispatchQueue.global(qos: .background).async { // 非同期でネットワークリクエストをバックグラウンドで実行
            
            self.weatherService.fetchWeather(for: latitude, longitude: longitude) { weather in
                // データが取得できたらUIをメインスレッドで更新
                if let weather = weather {
                    DispatchQueue.main.async {
                        self.temperature = String(format: "%.0f°C", weather.temperature)
                        self.description = weather.description
                        self.weatherType = self.getWeatherType(from: weather.description, weatherCode: weather.weatherCode)
                        self.high = String(format: "H: %.0f°C", weather.high)
                        self.low = String(format: "L: %.0f°C", weather.low)
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

//夜の時間を作りたい
let nightStartHour = 18
// 現在の時刻を取得する
func getCurrentHour() -> Int {
    let currentTime = Date()
    let calendar = Calendar.current
    return calendar.component(.hour, from: currentTime)
}
