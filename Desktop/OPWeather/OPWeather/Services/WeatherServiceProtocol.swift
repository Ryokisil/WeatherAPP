
import Foundation

// WeatherService用のプロトコル定義
protocol WeatherServiceProtocol {
    func fetchWeather(for city: String, completion: @escaping (WeatherData?) -> Void)
    func fetchWeather(for latitude: Double, longitude: Double, completion: @escaping (WeatherData?) -> Void)
}
