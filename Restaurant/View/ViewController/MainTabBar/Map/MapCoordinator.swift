//
//  MapCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/16.
//

import UIKit
import RxSwift

class MapCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]
    
    var afterSearchingRestaurantSubject: PublishSubject<([RestaurantModel],Bool)> = PublishSubject<([RestaurantModel],Bool)>() //요약 정보나 근처 식당 리스트에서 즐겨찾기 하면 맵 현행화 시키기 위함
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
        
        print("MapCoordinator init")
    }
    
    deinit {
        print("MapCoordinator Deinit")
    }
    
    func start() {
        var map = MapViewController.instantiate()
        map.coordinator = self
        map.bind(viewModel: MapViewModel(afterSearchingRestaurantSubject))
        
        presenter.pushViewController(map, animated: false)
    }
}

extension MapCoordinator {
    func presentNoRestaurantNearby() {
        let coordinator = NoRestaurantNearbyCoordinator(presenter: presenter, afterSearchingRestaurantSubject)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.noRestaurantNearby()
    }
    
    func restaurantSummaryInformation(restaurant: RestaurantModel, latitude: Double, longitude: Double) {
        let coordinator = RestaurantSummaryInformationCoordinator(presenter: presenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.restaurant = restaurant
        coordinator.latitude = latitude
        coordinator.longitude = longitude
        coordinator.afterSearchingRestaurantSubject = afterSearchingRestaurantSubject
        coordinator.start()
    }
    
    func pushNearbyRestaurants(nearbyRestaurants: [RestaurantModel], latitude: Double, longitude: Double) {
        let coordinator = NearbyRestaurantsCoordinator(presenter: presenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.latitude = latitude
        coordinator.longitude = longitude
        coordinator.afterSearchingRestaurantSubject = afterSearchingRestaurantSubject
        coordinator.start(nearbyRestaurants: nearbyRestaurants)
    }
}
