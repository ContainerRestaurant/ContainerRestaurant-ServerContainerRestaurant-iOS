//
//  SettingCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/08/09.
//

import UIKit

class SettingCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]

    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []

        print("SettingCoordinator init")
    }

    deinit {
        print("SettingCoordinator Deinit")
    }

    func start() {
        let settingViewController = SettingViewController.instantiate()
        settingViewController.coordinator = self
//        settingViewController.bind(viewModel: NearbyRestaurantsViewModel(nearbyRestaurants: nearbyRestaurants))

        presenter.pushViewController(settingViewController, animated: true)
    }
}
