//
//  NearbyRestaurantsCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/26.
//

import UIKit

class NearbyRestaurantsCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]
    
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
        nearbyRestaurantsViewController.bind(viewModel: NearbyRestaurantsViewModel(nearbyRestaurants: nearbyRestaurants))
        
        presenter.pushViewController(nearbyRestaurantsViewController, animated: true)
    }
}
