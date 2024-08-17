//
//  LocationManager.swift
//  OPWeather
//
//  Created by silvia on 2024/06/23.
//

import Foundation
import CoreLocation

// LocationManagerクラスは、位置情報の取得と管理を行います
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    // CLLocationManagerのインスタンスを保持
    private let locationManager = CLLocationManager()
    
    // 位置情報を公開するプロパティ
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus
    
    // 初期化メソッド
    override init() {
        // 現在の認証ステータスを取得
        self.authorizationStatus = locationManager.authorizationStatus
        super.init()
        // デリゲートを設定
        locationManager.delegate = self
        // 位置情報の精度を最高に設定
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 位置情報使用許可をリクエスト
        locationManager.requestWhenInUseAuthorization()
        // 位置情報の更新を開始
        locationManager.startUpdatingLocation()
    }
    
    // 位置情報の更新を開始するメソッド
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    // 位置情報が更新されたときに呼び出されるデリゲートメソッド
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 最新の位置情報を取得
        if let location = locations.first {
            // メインスレッドで位置情報を更新
            DispatchQueue.main.async {
                print("Location updated: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                self.location = location
            }
        }
    }
    
    // 認証ステータスが変更されたときに呼び出されるデリゲートメソッド
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // メインスレッドで認証ステータスを更新
        DispatchQueue.main.async {
            print("Authorization status changed: \(status.rawValue)")
            self.authorizationStatus = status
            // 許可されている場合、位置情報の更新を開始
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                self.startUpdatingLocation()
            } else {
                print("Location access denied")
            }
        }
    }
}




