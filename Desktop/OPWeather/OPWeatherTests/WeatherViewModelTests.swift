
//データ取得が正しく出来てるかのテスト
import XCTest
@testable import OPWeather

final class WeatherViewModelTests: XCTestCase {
    var viewModel: WeatherViewModel!
    var mockWeatherService: MockWeatherService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockWeatherService = MockWeatherService() // モックサービスを使う
        viewModel = WeatherViewModel(weatherService: mockWeatherService!)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockWeatherService = nil
        try super.tearDownWithError()
    }

    func testFetchWeatherSuccess() throws {
        // 正常なケースのテスト
        let expectation = self.expectation(description: "Weather data should be fetched successfully")
        viewModel.fetchWeather(for: "Tokyo")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(self.viewModel.temperature, "25°C", "Temperature should be 25°C")
            XCTAssertEqual(self.viewModel.description, "Clear", "Description should be Clear")
            XCTAssertEqual(self.viewModel.high, "H: 28°C", "High temperature should be 28°C")
            XCTAssertEqual(self.viewModel.low, "L: 22°C", "Low temperature should be 22°C")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testFetchWeatherFailure() throws {
        // エラーケースのテスト
        mockWeatherService.shouldReturnError = true // エラーを返すように設定
        let expectation = self.expectation(description: "Weather data fetch should fail")
        
        viewModel.fetchWeather(for: "InvalidCity")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(self.viewModel.temperature, "", "Temperature should be empty")
            XCTAssertEqual(self.viewModel.description, "", "Description should be empty")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5.0, handler: nil)
    }
}
