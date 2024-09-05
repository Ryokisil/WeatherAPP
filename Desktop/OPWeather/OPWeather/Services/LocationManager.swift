
import Foundation
import CoreLocation

// ユーザーの位置情報を取得・管理するクラス
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()

    @Published var location: CLLocation? // ユーザーの現在地を保持
    @Published var authorizationStatus: CLAuthorizationStatus // 位置情報サービスの許可状態
    
    // 初期設定
    override init() {
        self.authorizationStatus = locationManager.authorizationStatus
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // 位置情報の更新を開始
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    // ユーザーの現在の位置情報を取得してUIを更新したい
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            DispatchQueue.main.async {
                print("Location updated: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                self.location = location  // 最新の位置情報を更新
            }
        }
    }
    
    // 位置情報アクセスのステータスが変更されたときに、行う処理
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        DispatchQueue.main.async {
            print("Authorization status changed: \(status.rawValue)")
            self.authorizationStatus = status  // 認証ステータスを更新
            
            // 許可されている場合、位置情報の更新を開始
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                self.startUpdatingLocation()
            } else {
                print("Location access denied")   // 許可がない場合の処理（デバッグ用）
            }
        }
    }
}
