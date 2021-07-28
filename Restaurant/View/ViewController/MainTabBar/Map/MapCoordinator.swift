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
    
    var afterSearchingRestaurantSubject: PublishSubject<[RestaurantModel]> = PublishSubject<[RestaurantModel]>()
    
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
    
    func restaurantSummaryInformation(restaurant: RestaurantModel) {
        let coordinator = RestaurantSummaryInformationCoordinator(presenter: presenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.restaurant = restaurant
        coordinator.start()
    }
    
    func pushNearbyRestaurants(nearbyRestaurants: [RestaurantModel]) {
        let coordinator = NearbyRestaurantsCoordinator(presenter: presenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start(nearbyRestaurants: nearbyRestaurants)
    }
}
