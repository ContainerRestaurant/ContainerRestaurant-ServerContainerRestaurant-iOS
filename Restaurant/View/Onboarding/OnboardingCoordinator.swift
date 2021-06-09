//
//  OnboardingCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/07.
//

import UIKit

class OnboardingCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]

    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }

    func start() {
        let onboarding = OnboardingViewController.instantiate()
        onboarding.coordinator = self
        presenter.pushViewController(onboarding, animated: false)
    }
}

extension OnboardingCoordinator {
    func closeOnboarding() {
        let coordinator = MainTabBarCoordinator(presenter: presenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
