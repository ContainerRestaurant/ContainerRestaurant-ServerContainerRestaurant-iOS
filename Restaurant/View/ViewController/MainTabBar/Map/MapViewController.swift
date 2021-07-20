//
//  MapViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/06.
//

import UIKit
import NMapsMap

class MapViewController: BaseViewController, Storyboard, ViewModelBindableType {
    var viewModel: MapViewModel!
    weak var coordinator: MapCoordinator?
    var mapView = NMFMapView()
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var myLocationButton: UIButton!
    @IBAction func moveToMyLocation(_ sender: Any) {
        moveToMyLocationOnMap()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setMapView()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        print("MapViewController viewDidLoad()")
    }
    
    deinit {
        print("MapViewController Deinit")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func bindingView() {
        print("왔구나 \(viewModel.nearbyRestaurants)")
    }

    private func setMapView() {
        locationManager.delegate = self
        getLocationUsagePermission()

        let (viewX, viewY) = (self.view.frame.minX, self.view.frame.minY)
        let (viewWidth, viewHeight) = (self.view.frame.width, self.view.frame.height - CGFloat(83) + (Common.isNotchPhone ? CGFloat(0) : Common.homeBarHeight))
        let viewCGRect = CGRect(x: viewX, y: viewY, width: viewWidth, height: viewHeight)
        mapView = NMFMapView(frame: viewCGRect)
        mapView.positionMode = .normal
        
        self.mainView.addSubview(mapView)
        self.setMyLocationIcon()
        self.moveToMyLocationOnMap()
        
    }
}

extension MapViewController: CLLocationManagerDelegate {
    private func getLocationUsagePermission() {
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
    
    func setMyLocationIcon() {
        guard let locationCoordinate = locationManager.location?.coordinate else { return }
        
        let locationOverlay = mapView.locationOverlay
        locationOverlay.hidden = false
        locationOverlay.location = NMGLatLng(lat: locationCoordinate.latitude, lng: locationCoordinate.longitude)
    }
    
    func moveToMyLocationOnMap() {
        guard let locationCoordinate = locationManager.location?.coordinate else { return }
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locationCoordinate.latitude, lng: locationCoordinate.longitude))
        cameraUpdate.animation = .easeOut
        cameraUpdate.animationDuration = 1
        mapView.moveCamera(cameraUpdate)
    }
}
