
//ユニットテストで使うデータ類
import Foundation
@testable import OPWeather

class MockWeatherService: WeatherServiceProtocol {
    var shouldReturnError = false
    var mockWeatherData: WeatherData?

    func fetchWeather(for city: String, completion: @escaping (WeatherData?) -> Void) {
        if shouldReturnError {
            completion(nil as WeatherData?)
        } else {
            let mockWeatherData = WeatherData(
                temperature: 25.0,
                description: "Clear",
                high: 28.0,
                low: 22.0,
                weatherCode: Int(800)
            )
            completion(mockWeatherData)
        }
    }

    func fetchWeather(for latitude: Double, longitude: Double, completion: @escaping (WeatherData?) -> Void) {
        if shouldReturnError {
            completion(nil as WeatherData?)
        } else {
            let mockWeatherData = WeatherData(
                temperature: 25.0,
                description: "Clear",
                high: 28.0,
                low: 22.0,
                weatherCode: Int(800)
            )
            completion(mockWeatherData)
        }
    }
}

