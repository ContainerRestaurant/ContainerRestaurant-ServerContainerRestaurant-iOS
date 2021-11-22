//
//  NearbyRestaurantsCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/26.
//

import UIKit
import RxSwift

class NearbyRestaurantsCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]

    var latitude: Double?
    var longitude: Double?
    var afterSearchingRestaurantSubject: PublishSubject<([RestaurantModel],Bool)>?
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
        
        print("NearbyRestaurantsCoordinator init")
    }
    
    deinit {
        print("NearbyRestaurantsCoordinator Deinit")
    }
    
    func start(nearbyRestaurants: [RestaurantModel]) {
        var nearbyRestaurantsViewController = NearbyRestaurantsViewController.instantiate()
        nearbyRestaurantsViewController.coordinator = self
        nearbyRestaurantsViewController.bind(viewModel: NearbyRestaurantsViewModel(nearbyRestaurants: nearbyRestaurants, self.latitude ?? 0.0, self.longitude ?? 0.0, self.afterSearchingRestaurantSubject ?? PublishSubject<([RestaurantModel],Bool)>()))
        
        presenter.pushViewController(nearbyRestaurantsViewController, animated: true)
    }

    func restaurantSummaryInformation(restaurant: RestaurantModel) {
        let coordinator = RestaurantSummaryInformationCoordinator(presenter: presenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.restaurant = restaurant
        coordinator.start()
    }
}
