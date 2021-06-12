//
//  MapViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/06.
//

import UIKit
import NMapsMap

class MapViewController: BaseViewController, Storyboard {
    weak var coordinator: MapCoordinator?
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var mainView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setMapView()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func setMapView() {
        locationManager.delegate = self
        getLocationUsagePermission()

        let (viewX, viewY) = (self.view.frame.minX, self.view.frame.minY)
        let (viewWidth, viewHeight) = (self.view.frame.width, self.view.frame.height - CGFloat(83) + (Common.isNotchPhone ? CGFloat(0) : Common.homeBarHeight))
        let viewCGRect = CGRect(x: viewX, y: viewY, width: viewWidth, height: viewHeight)
        let mapView = NMFNaverMapView(frame: viewCGRect)
        mapView.showLocationButton = true
        mapView.positionMode = .normal

        self.view.addSubview(mapView)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    private func getLocationUsagePermission() {
//        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
        case .restricted, .notDetermined:
            print("GPS 권한 설정되지 않음")
            getLocationUsagePermission()
        case .denied:
            print("GPS 권한 요청 거부됨")
            getLocationUsagePermission()
        default:
            print("GPS: Default")
        }
    }
}
