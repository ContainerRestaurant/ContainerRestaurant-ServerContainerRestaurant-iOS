//
//  MapViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/06.
//

import UIKit
import NMapsMap
import RxSwift

class MapViewController: BaseViewController, Storyboard, ViewModelBindableType {
    var viewModel: MapViewModel!
    weak var coordinator: MapCoordinator?
    var mapView = NMFMapView()
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var showListButton: UIButton!
    @IBAction func showList(_ sender: Any) {
        pushNearbyRestaurants()
    }
    @IBOutlet weak var myLocationButton: UIButton!
    @IBAction func moveToMyLocation(_ sender: Any) {
        moveToMyLocationOnMap()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("MapViewController viewDidLoad()")
    }
    
    deinit {
        print("MapViewController Deinit")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        if self.viewModel.isFirstEntry {
            setMapView()
            self.viewModel.isFirstEntry = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func bindingView() {
        viewModel.nearbyRestaurantsFlag.subscribe(onNext: { [weak self] in
            if let nearbyRestaurants = self?.viewModel.nearbyRestaurants {
                if nearbyRestaurants.isEmpty {
                    self?.coordinator?.presentNoRestaurantNearby()
                } else {
                    self?.setMarker()
                }
            } else {
                self?.coordinator?.presentNoRestaurantNearby()
            }
        })
        .disposed(by: disposeBag)
    }
}

extension MapViewController {
    private func setMapView() {
        locationManager.delegate = self
        getLocationUsagePermission()

        let (fullWidth, fullHeight) = (UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        let bottomBarSectionHeight = Common.tabBarHeight + (Common.isNotchPhone ? Common.homeBarHeight : 0)
        let (viewWidth, viewHeight) = (fullWidth, fullHeight - bottomBarSectionHeight)
        let viewCGRect = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        mapView = NMFMapView(frame: viewCGRect)
        mapView.positionMode = .normal
        
        self.mainView.addSubview(mapView)
        self.setMyLocationIcon()
        self.moveToMyLocationOnMap()
        self.viewModel.fetchNearbyRestaurants()
    }
    
    private func setMarker() {
        for restaurant in self.viewModel.nearbyRestaurants {
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: restaurant.latitude, lng: restaurant.longitude)
            marker.iconImage = NMFOverlayImage(name: "mapMarker")
            marker.width = 51
            marker.height = 56
            marker.mapView = mapView
            
            let handler = { [weak self] (overlay: NMFOverlay) -> Bool in
                self?.coordinator?.restaurantSummaryInformation()
                
                return true
            }
            marker.touchHandler = handler
        }
    }
    
    private func pushNearbyRestaurants() {
        coordinator?.pushNearbyRestaurants(nearbyRestaurants: viewModel.nearbyRestaurants)
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
            //setMapView()에 있는 세 method는 권한 설정 전에 호출돼서 현재 위치값을 못가져오므로 권한 설정 이후에도 다시 한 번 호출
            self.setMyLocationIcon()
            self.moveToMyLocationOnMap()
            self.viewModel.fetchNearbyRestaurants()
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
        self.viewModel.latitude = locationCoordinate.latitude
        self.viewModel.longitude = locationCoordinate.longitude
        
        let locationOverlay = mapView.locationOverlay
        locationOverlay.hidden = false
        locationOverlay.location = NMGLatLng(lat: viewModel.latitude, lng: viewModel.longitude)
    }
    
    func moveToMyLocationOnMap() {
        guard let locationCoordinate = locationManager.location?.coordinate else { return }
        self.viewModel.latitude = locationCoordinate.latitude
        self.viewModel.longitude = locationCoordinate.longitude
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: viewModel.latitude, lng: viewModel.longitude))
        cameraUpdate.animation = .easeOut
        cameraUpdate.animationDuration = 1
        mapView.moveCamera(cameraUpdate)
    }
}
