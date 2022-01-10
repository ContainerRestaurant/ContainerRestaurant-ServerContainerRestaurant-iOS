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
    static var mapNavigationBarAnimated = false
    var viewModel: MapViewModel!
    weak var coordinator: MapCoordinator?
    var mapView = NMFMapView()
    var locationManager = CLLocationManager()
    var markers: [NMFMarker] = []
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var searchCurrentLocationButton: UIButton!
    @IBOutlet weak var myLocationButton: UIButton!
    @IBOutlet weak var showListButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("MapViewController viewDidLoad()")
    }
    
    deinit {
        print("MapViewController Deinit")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: MapViewController.mapNavigationBarAnimated)
        if self.viewModel.isFirstEntry {
            setMapView()
            self.viewModel.isFirstEntry = false
        }

        //피드 상세에서 식당 정보 눌렀을 경우
        if RestaurantLocation.sharedInstance.isEntryRestaurantInformation {
            viewModel.latitudeInCenterOfMap = RestaurantLocation.sharedInstance.latitude
            viewModel.longitudeInCeterOfMap = RestaurantLocation.sharedInstance.longtitude
            moveToLocationOnMap(latitude: RestaurantLocation.sharedInstance.latitude, longitude: RestaurantLocation.sharedInstance.longtitude)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        MapViewController.mapNavigationBarAnimated = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.removeMarkersIcon()
//        disposeBag = DisposeBag() 
    }
    
    func bindingView() {
        searchCurrentLocationButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.fetchCurrentNearbyRestaurants()
                self?.removeMarkers()
            })
            .disposed(by: disposeBag)

        myLocationButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }

                let status = CLLocationManager.authorizationStatus()

                if status == CLAuthorizationStatus.denied || status == CLAuthorizationStatus.restricted {
                    let alter = UIAlertController(title: "위치 서비스를 사용할 수 없습니다.", message: "위치 서비스 활성화를 위해\n권한 설정으로 이동하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
                    let logOkAction = UIAlertAction(title: "이동", style: UIAlertAction.Style.default) { (action: UIAlertAction) in
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(NSURL(string:UIApplication.openSettingsURLString)! as URL)
                        } else {
                            UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
                        }
                    }
                    let logNoAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.destructive){ (action: UIAlertAction) in
                        self.dismiss(animated: false, completion: nil)
                    }
                    alter.addAction(logNoAction)
                    alter.addAction(logOkAction)

                    self.present(alter, animated: true, completion: nil)
                } else {
                    self.moveToMyLocationOnMap()
                }
            })
            .disposed(by: disposeBag)

        showListButton.rx.tap
            .subscribe(onNext: { [weak self] in self?.pushNearbyRestaurants() })
            .disposed(by: disposeBag)

        viewModel.myNearbyRestaurantsFlag
            .subscribe(onNext: { [weak self] isFavoriteAction in
                if isFavoriteAction {
                    self?.setMarkers()
                } else {
                    guard let nearbyRestaurants = self?.viewModel.nearbyRestaurants,
                          !nearbyRestaurants.isEmpty else {
                              if !RestaurantLocation.sharedInstance.isEntryRestaurantInformation {
                                  self?.coordinator?.presentNoRestaurantNearby()
                              }
                              return
                    }

                    self?.setMarkers()
                }
            })
            .disposed(by: disposeBag)

        viewModel.currentNearbyRestaurantsFlag
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }

                if self.viewModel.nearbyRestaurants.isEmpty {
                    ToastMessage.shared.show(str: "이 위치에는 아직 용기낸 식당이 없어요!")
                } else {
                    self.setMarkers()
                }
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - 지도 뷰 관련
extension MapViewController {
    private func setMapView() {
        locationManager.delegate = self
        getLocationUsagePermission()

        let (fullWidth, fullHeight) = (UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        let bottomBarSectionHeight = Common.tabBarHeight + (UIDevice.current.hasNotch ? Common.homeBarHeight : 0)
        let (viewWidth, viewHeight) = (fullWidth, fullHeight - bottomBarSectionHeight)
        let viewCGRect = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        mapView = NMFMapView(frame: viewCGRect)
        mapView.positionMode = .normal
        mapView.addCameraDelegate(delegate: self)
        
        self.mainView.addSubview(mapView)
        self.setMyLocationIcon()
        self.moveToMyLocationOnMap()

        if checkGPSPermission() {
            self.viewModel.fetchMyNearbyRestaurants()
        }
    }

    private func setMarkers() {
        for restaurant in self.viewModel.nearbyRestaurants {
            let marker = NMFMarker()
            setNormalMarkersIcon(marker: marker)
            marker.position = NMGLatLng(lat: restaurant.latitude, lng: restaurant.longitude)
            marker.mapView = mapView
            self.markers.append(marker)

            if marker.position == NMGLatLng(lat: RestaurantLocation.sharedInstance.latitude, lng: RestaurantLocation.sharedInstance.longtitude) {
                self.setClickedMarkersIcon(marker: marker)
                self.coordinator?.restaurantSummaryInformation(restaurant: restaurant, latitude: self.viewModel.latitudeInCenterOfMap, longitude: self.viewModel.longitudeInCeterOfMap)

                RestaurantLocation.sharedInstance.isEntryRestaurantInformation = false
                RestaurantLocation.sharedInstance.latitude = 0.0
                RestaurantLocation.sharedInstance.longtitude = 0.0
            }
            
            let handler = { [weak self] (overlay: NMFOverlay) -> Bool in
                self?.removeMarkersIcon()
                self?.setClickedMarkersIcon(marker: marker)

                self?.moveToLocationOnMap(latitude: restaurant.latitude, longitude: restaurant.longitude)

                self?.coordinator?.restaurantSummaryInformation(restaurant: restaurant, latitude: self?.viewModel.latitudeInCenterOfMap ?? 0.0, longitude: self?.viewModel.longitudeInCeterOfMap ?? 0.0)
                
                return true
            }
            marker.touchHandler = handler
        }
    }

    private func removeMarkers() {
        self.markers.forEach { $0.mapView = nil }
        self.markers.removeAll()
    }

    private func removeMarkersIcon() {
        for marker in markers {
            setNormalMarkersIcon(marker: marker)
        }
    }

    private func setNormalMarkersIcon(marker: NMFMarker) {
        marker.iconImage = NMFOverlayImage(name: "mapMarkerS")
        marker.width = 30
        marker.height = 30
    }

    private func setClickedMarkersIcon(marker: NMFMarker) {
        marker.iconImage = NMFOverlayImage(name: "mapMarker")
        marker.width = 51
        marker.height = 56
    }

    private func pushNearbyRestaurants() {
        coordinator?.pushNearbyRestaurants(nearbyRestaurants: viewModel.nearbyRestaurants, latitude: self.viewModel.latitudeInCenterOfMap, longitude: self.viewModel.longitudeInCeterOfMap)
    }

    func setMyLocationIcon() {
        guard let locationCoordinate = locationManager.location?.coordinate else { return }
        self.viewModel.myLatitude = locationCoordinate.latitude
        self.viewModel.myLongitude = locationCoordinate.longitude

        let locationOverlay = mapView.locationOverlay
        locationOverlay.hidden = false
        locationOverlay.location = NMGLatLng(lat: viewModel.myLatitude, lng: viewModel.myLongitude)
    }

    func moveToMyLocationOnMap() {
        guard let locationCoordinate = locationManager.location?.coordinate else { return }
        self.viewModel.myLatitude = locationCoordinate.latitude
        self.viewModel.myLongitude = locationCoordinate.longitude

        moveToLocationOnMap(latitude: viewModel.myLatitude, longitude: viewModel.myLongitude)
    }

    func moveToLocationOnMap(latitude: Double, longitude: Double) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude))
        cameraUpdate.animation = .easeOut
        cameraUpdate.animationDuration = 1
        mapView.moveCamera(cameraUpdate) { [weak self] _ in
            if RestaurantLocation.sharedInstance.isEntryRestaurantInformation {
                self?.removeMarkers()
                self?.viewModel.fetchCurrentNearbyRestaurants()
            }
        }
    }
}

//MARK: - 카메라 이동 감지
extension MapViewController: NMFMapViewCameraDelegate {
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        print(mapView.cameraPosition.target.lat)
        print(mapView.cameraPosition.target.lng)
        self.viewModel.latitudeInCenterOfMap = mapView.cameraPosition.target.lat
        self.viewModel.longitudeInCeterOfMap = mapView.cameraPosition.target.lng
    }
}

//MARK: - GPS 권한 관련
extension MapViewController: CLLocationManagerDelegate {
    private func getLocationUsagePermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
//            UserDataManager.sharedInstance.isMapAuthorized = true
          
            //setMapView()에 있는 세 method는 권한 설정 전에 호출돼서 현재 위치값을 못가져오므로 권한 설정 이후에도 다시 한 번 호출
            self.setMyLocationIcon()
            self.moveToMyLocationOnMap()
            self.viewModel.fetchMyNearbyRestaurants()
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

    func checkGPSPermission() -> Bool {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS: 권한 있음")
            return true
        case .restricted, .notDetermined:
            print("GPS: 아직 선택하지 않음")
            return false
        case .denied:
            print("GPS: 권한 없음")
            return false
        default:
            print("GPS: Default")
            return false
        }
    }
}
