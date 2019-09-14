//
//  MapViewController.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/09/14.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    lazy var mapView: MKMapView = {
        let v = MKMapView()
        view.addSubview(v)
        return v
    }()
    
    var locationManager: CLLocationManager!
    var query = "精神科"
    var clLocation2D: CLLocationCoordinate2D? {
        didSet {
            setUpMap()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeConstraints()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestLocation()
    }
    
    func makeConstraints() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    func setUpMap() {
        mapView.setCenter(clLocation2D ?? CLLocationCoordinate2D() ,animated:true)
        // 縮尺を設定
        let region = MKCoordinateRegion(center: clLocation2D ?? CLLocationCoordinate2D(),
                                        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        
        Map.search(query: query, region: region) { [weak self] (result) in
            switch result {
            case .success(let mapItems):
                for map in mapItems {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = map.placemark.coordinate
                    annotation.title = map.name ?? "名前がありません"
                    self?.mapView.addAnnotation(annotation)
                    
                    print("name: \(map.name ?? "no name")")
                    print("coordinate: \(map.placemark.coordinate.latitude) \(map.placemark.coordinate.latitude)")
                }
            case .failure(let error):
                print("error \(error.localizedDescription)")
            }
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = clLocation2D ?? CLLocationCoordinate2D()
        annotation.title = "検索地"
        mapView.addAnnotation(annotation)
        
        mapView.setRegion(region,animated:true)
        
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("ユーザーはこのアプリケーションに関してまだ選択を行っていません")
            locationManager.requestWhenInUseAuthorization()
            break
        case .denied:
            print("ローケーションサービスの設定が「無効」になっています (ユーザーによって、明示的に拒否されています）")
            // 「設定 > プライバシー > 位置情報サービス で、位置情報サービスの利用を許可して下さい」を表示する
            break
        case .restricted:
            print("このアプリケーションは位置情報サービスを使用できません(ユーザによって拒否されたわけではありません)")
            // 「このアプリは、位置情報を取得できないために、正常に動作できません」を表示する
            break
        case .authorizedAlways:
            print("常時、位置情報の取得が許可されています。")
            // 位置情報取得の開始処理
            break
        case .authorizedWhenInUse:
            print("起動時のみ、位置情報の取得が許可されています。")
            // 位置情報取得の開始処理
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            clLocation2D = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("一情報の取得に失敗")
    }
    
}

struct Map {
    enum Result<T> {
        case success(T)
        case failure(Error)
    }
    
    static func search(query: String, region: MKCoordinateRegion? = nil, completionHandler: @escaping (Result<[MKMapItem]>) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        
        if let region = region {
            request.region = region
        }
        
        MKLocalSearch(request: request).start { (response, error) in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            completionHandler(.success(response?.mapItems ?? []))
        }
    }
}
