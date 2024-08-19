
import Foundation

// WeatherData 構造体の定義、Decodable プロトコルに準拠
struct WeatherData: Decodable {
    let temperature: Double
    let description: String
    let high: Double
    let low: Double
    let weatherCode: Int

    // APIレスポンスのトップレベルキーに対応するコーディングキーを定義
    private enum CodingKeys: String, CodingKey {
        case main
        case weather
    }

    // main キー内のサブキーを定義
    private enum MainKeys: String, CodingKey {
        case temp
        case tempMax = "temp_max"
        case tempMin = "temp_min"
    }

    // weather キー内のサブキーを定義
    private enum WeatherKeys: String, CodingKey {
        case description
        case id
    }

    // Decodable プロトコルに準拠するための初期化メソッド
    init(from decoder: Decoder) throws {
        // トップレベルコンテナをデコード
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // main コンテナをデコードし、そのサブキーもデコード
        let mainContainer = try container.nestedContainer(keyedBy: MainKeys.self, forKey: .main)
        self.temperature = try mainContainer.decode(Double.self, forKey: .temp)
        self.high = try mainContainer.decode(Double.self, forKey: .tempMax)
        self.low = try mainContainer.decode(Double.self, forKey: .tempMin)
        
        // weather コンテナをデコードし、そのサブキーもデコード
        var weatherContainer = try container.nestedUnkeyedContainer(forKey: .weather)
        let weatherDescriptionContainer = try weatherContainer.nestedContainer(keyedBy: WeatherKeys.self)
        self.description = try weatherDescriptionContainer.decode(String.self, forKey: .description)
        self.weatherCode = try weatherDescriptionContainer.decode(Int.self, forKey: .id)
    }
}


