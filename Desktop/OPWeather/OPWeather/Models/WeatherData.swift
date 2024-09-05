
import Foundation

// WeatherData 構造体の定義、Decodable プロトコルに準拠させたい
struct WeatherData: Decodable {
    let temperature: Double
    let description: String
    let weatherCode: Int
    let high: Double
    let low: Double
    
    // カスタムイニシャライザを追加
    init(temperature: Double, description: String, high: Double, low: Double, weatherCode: Int) {
        self.temperature = temperature
        self.description = description
        self.high = high
        self.low = low
        self.weatherCode = weatherCode
    }
    

    // APIレスポンスのトップレベルキーに対応するコーディングキー
    private enum CodingKeys: String, CodingKey {
        case main
        case weather
    }

    // main キー内のサブキー
    private enum MainKeys: String, CodingKey {
        case temp
        case tempMax = "temp_max"
        case tempMin = "temp_min"
    }

    // weather キー内のサブキー
    private enum WeatherKeys: String, CodingKey {
        case description
        case id
    }

    // Decodable プロトコルに準拠させたい
    init(from decoder: Decoder) throws {
        // トップレベルコンテナをデコード
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // main コンテナとサブキーもデコード
        let mainContainer = try container.nestedContainer(keyedBy: MainKeys.self, forKey: .main)
        self.temperature = try mainContainer.decode(Double.self, forKey: .temp)
        self.high = try mainContainer.decode(Double.self, forKey: .tempMax)
        self.low = try mainContainer.decode(Double.self, forKey: .tempMin)
        
        // weather コンテナとサブキーもデコード
        var weatherContainer = try container.nestedUnkeyedContainer(forKey: .weather)
        let weatherDescriptionContainer = try weatherContainer.nestedContainer(keyedBy: WeatherKeys.self)
        self.description = try weatherDescriptionContainer.decode(String.self, forKey: .description)
        self.weatherCode = try weatherDescriptionContainer.decode(Int.self, forKey: .id)
        print("WeatherCode: \(self.weatherCode), Description: \(self.description)")
    }
}
