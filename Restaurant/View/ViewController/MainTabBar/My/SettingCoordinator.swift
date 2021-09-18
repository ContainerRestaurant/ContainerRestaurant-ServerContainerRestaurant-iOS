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

extension SettingCoordinator {
    //개인정보 취급방침
    func pushPrivacyPolicy() {
        let coordinator = HTMLTextCoordinator(presenter: presenter)
        coordinator.delegate = self
        coordinator.htmlTextType = .privacyPolicy
        childCoordinators.append(coordinator)

        coordinator.start()
    }

    //이용약관
    func pushServiceAccessTerms() {
        let coordinator = HTMLTextCoordinator(presenter: presenter)
        coordinator.delegate = self
        coordinator.htmlTextType = .serviceAccessTerms
        childCoordinators.append(coordinator)

        coordinator.start()
    }
}
